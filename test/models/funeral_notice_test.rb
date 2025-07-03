require 'test_helper'

class FuneralNoticeTest < ActiveSupport::TestCase
  def setup
    @funeral_notice_attributes = {
      full_name: 'Test Person',
      content: 'Test content for indexing verification',
      published_on: Date.parse('2024-01-01'),
      source_link: 'https://example.com'
    }
  end

  def teardown
    # Clean up any created records
    FuneralNotice.destroy_all
  end

  test 'should generate hash_id on creation' do
    notice = FuneralNotice.create!(@funeral_notice_attributes)
    assert_not_nil notice.hash_id
    assert_equal 6, notice.hash_id.length
  end

  test 'should have unique hash_id' do
    notice1 = FuneralNotice.create!(@funeral_notice_attributes)
    notice2 = FuneralNotice.create!(@funeral_notice_attributes.merge(full_name: 'Another Person'))

    assert_not_equal notice1.hash_id, notice2.hash_id
  end

  test 'should generate pathname correctly' do
    notice = FuneralNotice.create!(@funeral_notice_attributes)
    expected_pathname = "2024-01-01/#{notice.full_name.parameterize}-#{notice.hash_id}"
    assert_equal expected_pathname, notice.pathname
  end

  test 'should generate route params correctly' do
    notice = FuneralNotice.create!(@funeral_notice_attributes)
    expected_params = {
      date: '2024-01-01',
      name_hash: "#{notice.full_name.parameterize}-#{notice.hash_id}"
    }
    assert_equal expected_params, notice.route_params
  end

  test 'should validate required fields' do
    notice = FuneralNotice.new
    assert_not notice.valid?
    assert_includes notice.errors[:full_name], "can't be blank"
    assert_includes notice.errors[:content], "can't be blank"
    assert_includes notice.errors[:published_on], "can't be blank"
    assert_includes notice.errors[:source_link], "can't be blank"
  end
end
