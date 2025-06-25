# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://funebres.enlaplata.com.ar"

SitemapGenerator::Sitemap.create do
  # Add the root path
  add '/', changefreq: 'daily', priority: 1.0

  # Add paginated funeral notice index pages
  # Estimate the number of pages based on FuneralNotice count and default per page (Pagy default is 20)
  per_page = 20
  total_notices = FuneralNotice.count
  total_pages = (total_notices.to_f / per_page).ceil

  (1..total_pages).each do |page|
    add "/funeral-notices?page=#{page}", changefreq: 'daily', priority: 0.8
  end

  # Add individual funeral notice pages
  FuneralNotice.find_each do |notice|
    add "/funeral-notices/#{notice.pathname}", 
        changefreq: 'monthly', 
        priority: 0.6,
        lastmod: notice.updated_at
  end
end 