require 'test_helper'

class FuneralNoticeRecoveryScraperTest < ActiveSupport::TestCase
  def setup
    @date = Date.parse('2024-01-01')
    @url = 'https://funebres.eldia.com/edis/20240101/funebres2.htm'
    FuneralNotice.where(published_on: @date).delete_all
  end

  test 'should create missing notices' do
    html = <<-HTML
      <div class="grid_10 funebres">
        <ul>
          <li class="c">JOHN DOE<br><span>(Q.E.P.D.) Falleció el 30/06/2025.- Su esposa: Jane Doe; sus hijos: John Jr. y Jane Jr. participan su fallecimiento.</span></li>
        </ul>
      </div>
    HTML

    # Mock URI.open to return our test HTML
    original_open = URI.method(:open)
    URI.define_singleton_method(:open) { |*_args| StringIO.new(html) }

    assert_difference 'FuneralNotice.count', 1 do
      FuneralNoticeRecoveryScraper.new(date: @date).call
    end

    notice = FuneralNotice.last
    assert_equal 'JOHN DOE', notice.full_name
    assert_equal '(Q.E.P.D.) Falleció el 30/06/2025.- Su esposa: Jane Doe; sus hijos: John Jr. y Jane Jr. ' \
                 'participan su fallecimiento.', notice.content
    assert_equal @date, notice.published_on

    # Restore original method
    URI.define_singleton_method(:open, original_open)
  end

  test 'should skip existing notices' do
    # Create an existing notice
    FuneralNotice.create!(
      full_name: 'JOHN DOE',
      content: '(Q.E.P.D.) Falleció el 30/06/2025.- Su esposa: Jane Doe; sus hijos: John Jr. y Jane Jr. ' \
               'participan su fallecimiento.',
      published_on: @date,
      source_link: @url
    )

    html = <<-HTML
      <div class="grid_10 funebres">
        <ul>
          <li class="c">JOHN DOE<br><span>(Q.E.P.D.) Falleció el 30/06/2025.- Su esposa: Jane Doe; sus hijos: John Jr. y Jane Jr. participan su fallecimiento.</span></li>
        </ul>
      </div>
    HTML

    # Mock URI.open to return our test HTML
    original_open = URI.method(:open)
    URI.define_singleton_method(:open) { |*_args| StringIO.new(html) }

    assert_no_difference 'FuneralNotice.count' do
      FuneralNoticeRecoveryScraper.new(date: @date).call
    end

    # Restore original method
    URI.define_singleton_method(:open, original_open)
  end
end
