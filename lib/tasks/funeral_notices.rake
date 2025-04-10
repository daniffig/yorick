namespace :funeral_notices do
  desc "Scrape funeral notices between a start_date and end_date (format: YYYY-MM-DD)"
  task scrape: :environment do
    puts "Usage: rake funeral_notices:scrape [start_date=YYYY-MM-DD end_date=YYYY-MM-DD]"

    start_date_str = ENV["start_date"]
    end_date_str   = ENV["end_date"]

    START_DATE = Date.parse("2006-05-02")
    today = Date.today

    begin
      start_date = start_date_str ? Date.parse(start_date_str) : START_DATE
      end_date   = end_date_str ? Date.parse(end_date_str) : today

      if start_date < START_DATE
        puts "❌ start_date cannot be before #{START_DATE}"
        exit(1)
      end

      if end_date > today
        puts "❌ end_date cannot be in the future (#{today})"
        exit(1)
      end

      (start_date..end_date).each do |date|
        begin
          FuneralNoticeScraper.new(date: date).call
        rescue ArgumentError => e
          puts "⏩ Skipping #{date}: #{e.message}"
        end
      end

      puts "✅ Scraping finished from #{start_date} to #{end_date}"
    rescue ArgumentError => e
      puts "❌ Invalid date format: #{e.message}"
      exit(1)
    end
  end
end
