class FuneralNoticesController < ApplicationController
  def index
    search_query = build_search_query(search_params)

    if search_query.present?
      base_scope = FuneralNoticesIndex
        .query(bool: { must: search_query })
        .order(published_on: :desc, id: :desc)

      total_count = base_scope.total_count

      @pagy = Pagy.new(count: total_count, page: params[:page] || 1)
      @funeral_notices = base_scope.offset(@pagy.offset).limit(@pagy.limit).records
    else
      @pagy, @funeral_notices = pagy(FuneralNotice.order(published_on: :desc, id: :desc))
    end

    # Set cache headers for index page
    fresh_when(@funeral_notices.compact, etag: [@funeral_notices, @pagy.page, search_params])
  end

  def show
    date_str = params[:date]
    name_hash = params[:name_hash]

    # Validate we have both parameters
    raise ActiveRecord::RecordNotFound if date_str.blank? || name_hash.blank?

    date = Date.parse(date_str)

    # Parse name-hash_id format (e.g., "mariana-santos-f6524f")
    raise ActiveRecord::RecordNotFound unless name_hash.include?('-')

    parts = name_hash.split('-')
    hash_id = parts.last # Last part is the hash
    name_dasherized = parts[0..-2].join('-') # Everything except last part is the name

    @funeral_notice = FuneralNotice.find_by(published_on: date, hash_id: hash_id)
    raise ActiveRecord::RecordNotFound unless @funeral_notice

    # Verify the name matches (additional security check)
    expected_name = @funeral_notice.full_name.parameterize
    unless name_dasherized == expected_name
      redirect_to funeral_notice_path(@funeral_notice.route_params), status: :moved_permanently
    end

    # Set cache headers for show page
    fresh_when(@funeral_notice, etag: @funeral_notice)
    Rails.logger.info "Found funeral notice: #{@funeral_notice.full_name} (ID: #{@funeral_notice.id})"
  end

  private

  def build_full_name_query(query)
    return if query.blank?

    {
      bool: {
        should: [
          {
            match_phrase: {
              full_name: {
                query: query,
                slop: 2,
                boost: 10
              }
            }
          },
          {
            match: {
              full_name: {
                query: query,
                operator: 'and',
                boost: 5
              }
            }
          },
          {
            match: {
              full_name: {
                query: query,
                fuzziness: 1,
                prefix_length: 2,
                max_expansions: 10
              }
            }
          }
        ]
      }
    }
  end

  def build_content_query(query)
    return if query.blank?

    {
      bool: {
        should: [
          {
            match_phrase: {
              content: {
                query: query,
                slop: 3,
                boost: 3
              }
            }
          },
          {
            match: {
              content: {
                query: query,
                operator: 'and',
                boost: 1
              }
            }
          }
        ]
      }
    }
  end

  def build_search_query(params)
    full_name_query = params[:full_name].to_s.strip
    content_query = params[:content].to_s.strip

    return unless [full_name_query, content_query].any?

    search_query = []
    search_query << build_full_name_query(full_name_query) if full_name_query.present?
    search_query << build_content_query(content_query) if content_query.present?

    search_query
  end

  def search_params
    params.except(:commit).permit(:full_name, :content)
  end
end
