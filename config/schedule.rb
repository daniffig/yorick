# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Set the environment variable for your cron jobs
set :environment, ENV['RAILS_ENV'] || 'development'
set :output, 'log/cron.log'

# Run the scraper every day at 2 AM (adjust the time as needed)
every 1.day, at: '12:00 pm' do
  rake "funeral_notices:scrape"
end

# Learn more: http://github.com/javan/whenever
