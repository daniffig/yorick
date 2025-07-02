START_DATE = Date.parse('2006-05-02')

# rubocop:disable Metrics/BlockLength
namespace :funeral_notices do
  desc 'Scrape or recover funeral notices between a start_date and end_date (format: YYYY-MM-DD). ' \
       'Set recovery_mode=true to run in recovery mode.'
  task scrape: :environment do
    puts 'Usage: rake funeral_notices:scrape [start_date=YYYY-MM-DD end_date=YYYY-MM-DD recovery_mode=true|false]'

    start_date_str = ENV.fetch('start_date', nil)
    end_date_str   = ENV.fetch('end_date', nil)
    recovery_mode  = ENV['recovery_mode'] == 'true'

    today = Time.zone.today

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

      klass = recovery_mode ? FuneralNoticeRecoveryScraper : FuneralNoticeScraper

      (start_date..end_date).each do |date|
        klass.new(date: date).call
      rescue ArgumentError => e
        puts "⏩ Skipping #{date}: #{e.message}"
      end

      mode_str = recovery_mode ? 'Recovery' : 'Scrape'
      puts "✅ #{mode_str} finished from #{start_date} to #{end_date}"
    rescue ArgumentError => e
      puts "❌ Invalid date format: #{e.message}"
      exit(1)
    end
  end
end
# rubocop:enable Metrics/BlockLength
