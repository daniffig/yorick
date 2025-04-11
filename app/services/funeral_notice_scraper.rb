class FuneralNoticeScraper
  BASE_URL = "https://funebres.eldia.com/edis/%{date}/funebres2.htm"
  START_DATE = Date.parse("2006-05-02")

  def initialize(date:)
    @date = date.is_a?(String) ? Date.parse(date) : date
    validate_date!
  end

  def call
    formatted_date = @date.strftime("%Y%m%d")
    url = BASE_URL % { date: formatted_date }

    unless url_available?(url)
      Rails.logger.info "🔍 Newspaper not found for #{@date} (URL: #{url})"
      return
    end

    puts "📅 Scraping #{@date} from #{url}"

    begin
      html = URI.open(url).read
      doc = Nokogiri::HTML(html)

      extract_notices(doc, @date, url)
    rescue => e
      Rails.logger.warn "⚠️ Error scraping #{url}: #{e.message}"
    end
  end

  private

  def validate_date!
    if @date < START_DATE
      raise ArgumentError, "Date must be on or after #{START_DATE}"
    end

    if FuneralNotice.exists?(published_on: @date)
      raise ArgumentError, "Funeral notices already exist for #{@date}"
    end
  end

  def url_available?(url)
    URI.open(url) { true }
  rescue OpenURI::HTTPError => e
    Rails.logger.info "URL not found: #{url} (#{e.message})"
    false
  end

  def extract_notices(doc, date, url)
    doc.css("div.grid_10.funebres li.c").each do |notice|
      span = notice.at('span')
      content = span&.text&.strip
      Rails.logger.info "Full Name: #{notice&.text}"

      span.remove if span
      full_name = notice.text.strip

      next if full_name.blank? || content.blank?

      FuneralNotice.find_or_create_by!(
        full_name: full_name,
        content: content,
        published_on: date,
        source_link: url
      )
    end
  end
end
