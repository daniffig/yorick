require 'open-uri'

class FuneralNoticeScraper
  BASE_URL = 'https://funebres.eldia.com/edis/%<date>s/funebres2.htm'.freeze
  START_DATE = Date.parse('2006-05-02')

  def initialize(date:)
    @date = date.is_a?(String) ? Date.parse(date) : date
    validate_date!
  end

  def call
    formatted_date = @date.strftime('%Y%m%d')
    url = format(BASE_URL, date: formatted_date)

    unless url_available?(url)
      Rails.logger.info "🔍 Newspaper not found for #{@date} (URL: #{url})"
      return
    end

    Rails.logger.debug { "📅 Scraping #{@date} from #{url}" }

    begin
      # rubocop:disable Security/Open
      html = URI.open(url).read
      # rubocop:enable Security/Open
      doc = Nokogiri::HTML(html)

      extract_notices(doc, @date, url)
    rescue StandardError => e
      Rails.logger.warn "⚠️ Error scraping #{url}: #{e.message}"
    end
  end

  private

  def validate_date!
    raise ArgumentError, "Date must be on or after #{START_DATE}" if @date < START_DATE

    return unless FuneralNotice.exists?(published_on: @date)

    raise ArgumentError, "Funeral notices already exist for #{@date}"
  end

  def url_available?(url)
    # rubocop:disable Security/Open
    URI.open(url) { true }
    # rubocop:enable Security/Open
  rescue OpenURI::HTTPError => e
    Rails.logger.info "URL not found: #{url} (#{e.message})"
    false
  end

  def extract_notices(doc, date, url)
    doc.css('div.grid_10.funebres li.c').each do |notice|
      span = notice.at('span')
      content = span&.text&.strip

      span&.remove
      full_name = notice.text.strip

      next if full_name.blank? || content.blank?

      Rails.logger.debug { "Found notice: #{full_name} - #{content[0..50]}..." }

      FuneralNotice.find_or_create_by!(
        full_name: full_name,
        content: content,
        published_on: date,
        source_link: url
      )
    end
  end
end
