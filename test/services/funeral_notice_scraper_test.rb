require 'test_helper'

class FuneralNoticeScraperTest < ActiveSupport::TestCase
  def setup
    @date = Date.parse('2024-01-01')
    @url = 'https://funebres.eldia.com/edis/20240101/funebres2.htm'
    FuneralNotice.where(published_on: @date).delete_all
  end

  test 'should create notices from HTML' do
    html = <<-HTML
      <div class="grid_10 funebres">
        <ul>
          <li class="c">JOHN DOE<br><span>(Q.E.P.D.) Falleció el 30/06/2025.- Su esposa: Jane Doe; sus hijos: John Jr. y Jane Jr. participan su fallecimiento.</span></li>
          <li class="c">JANE SMITH<br><span>(Q.E.P.D.) Falleció el 29/06/2025.- Sus hijos: Tom y Jerry participan su fallecimiento.</span></li>
        </ul>
      </div>
    HTML

    # Mock URI.open to return our test HTML
    original_open = URI.method(:open)
    URI.define_singleton_method(:open) { |*_args| StringIO.new(html) }

    assert_difference 'FuneralNotice.count', 2 do
      FuneralNoticeScraper.new(date: @date).call
    end

    notices = FuneralNotice.where(published_on: @date).order(:full_name)
    assert_equal 2, notices.count
    assert_equal 'JANE SMITH', notices.first.full_name
    assert_equal 'JOHN DOE', notices.last.full_name

    # Restore original method
    URI.define_singleton_method(:open, original_open)
  end

  test 'should raise error if notices already exist for date' do
    # Create an existing notice for the date
    FuneralNotice.create!(
      full_name: 'EXISTING PERSON',
      content: 'Existing content',
      published_on: @date,
      source_link: @url
    )

    assert_raises ArgumentError do
      FuneralNoticeScraper.new(date: @date)
    end
  end

  test 'should raise error for date before start date' do
    early_date = Date.parse('2006-05-01') # Before START_DATE

    assert_raises ArgumentError do
      FuneralNoticeScraper.new(date: early_date)
    end
  end

  test 'should handle empty HTML gracefully' do
    html = <<-HTML
      <div class="grid_10 funebres">
        <ul>
        </ul>
      </div>
    HTML

    # Mock URI.open to return our test HTML
    original_open = URI.method(:open)
    URI.define_singleton_method(:open) { |*_args| StringIO.new(html) }

    assert_no_difference 'FuneralNotice.count' do
      FuneralNoticeScraper.new(date: @date).call
    end

    # Restore original method
    URI.define_singleton_method(:open, original_open)
  end
end
