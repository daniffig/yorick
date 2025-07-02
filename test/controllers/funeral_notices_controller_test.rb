require 'test_helper'

class FuneralNoticesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @funeral_notice = funeral_notices(:one)
    @funeral_notice.update!(
      full_name: 'John Doe',
      content: 'Test content',
      published_on: Date.parse('2024-01-01'),
      hash_id: 'abc123'
    )
  end

  test 'should get index' do
    get funeral_notices_path
    assert_response :success
  end

  test 'should get show with valid parameters' do
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')
    name_hash = "#{@funeral_notice.full_name.parameterize}-#{@funeral_notice.hash_id}"

    get funeral_notice_path(date: date_str, name_hash: name_hash)
    assert_response :success
    assert_select 'h2', @funeral_notice.full_name
  end

  test "should redirect to correct URL when name doesn't match" do
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')
    wrong_name_hash = "wrong-name-#{@funeral_notice.hash_id}"

    get funeral_notice_path(date: date_str, name_hash: wrong_name_hash)
    assert_redirected_to funeral_notice_path(@funeral_notice.route_params)
    assert_response :moved_permanently
  end

  test 'should raise RecordNotFound when date is missing' do
    name_hash = "#{@funeral_notice.full_name.parameterize}-#{@funeral_notice.hash_id}"

    get funeral_notice_path(date: '', name_hash: name_hash)
    assert_response :not_found
  end

  test 'should raise RecordNotFound when name_hash is missing' do
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')

    get funeral_notice_path(date: date_str, name_hash: '')
    assert_response :not_found
  end

  test "should raise RecordNotFound when name_hash doesn't contain dash" do
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')

    get funeral_notice_path(date: date_str, name_hash: 'invalidhash')
    assert_response :not_found
  end

  test "should raise RecordNotFound when funeral notice doesn't exist" do
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')
    name_hash = 'non-existent-person-xyz789'

    get funeral_notice_path(date: date_str, name_hash: name_hash)
    assert_response :not_found
  end

  test 'should raise Date::Error when date is invalid' do
    name_hash = "#{@funeral_notice.full_name.parameterize}-#{@funeral_notice.hash_id}"

    assert_raises Date::Error do
      get funeral_notice_path(date: 'invalid-date', name_hash: name_hash)
    end
  end

  test 'should handle names with special characters' do
    @funeral_notice.update!(full_name: 'María José González-López')
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')
    name_hash = "#{@funeral_notice.full_name.parameterize}-#{@funeral_notice.hash_id}"

    get funeral_notice_path(date: date_str, name_hash: name_hash)
    assert_response :success
    assert_select 'h2', @funeral_notice.full_name
  end

  test 'should handle names with multiple dashes' do
    @funeral_notice.update!(full_name: 'Jean-Pierre Dupont-Martin')
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')
    name_hash = "#{@funeral_notice.full_name.parameterize}-#{@funeral_notice.hash_id}"

    get funeral_notice_path(date: date_str, name_hash: name_hash)
    assert_response :success
    assert_select 'h2', @funeral_notice.full_name
  end

  test 'should display funeral notice content' do
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')
    name_hash = "#{@funeral_notice.full_name.parameterize}-#{@funeral_notice.hash_id}"

    get funeral_notice_path(date: date_str, name_hash: name_hash)
    assert_response :success
    assert_select 'p', @funeral_notice.content
  end

  test 'should display published date' do
    date_str = @funeral_notice.published_on.strftime('%Y-%m-%d')
    name_hash = "#{@funeral_notice.full_name.parameterize}-#{@funeral_notice.hash_id}"

    get funeral_notice_path(date: date_str, name_hash: name_hash)
    assert_response :success
    assert_select 'p', /January 01, 2024/
  end
end
