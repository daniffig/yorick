class FuneralNoticesController < ApplicationController
  def index
    search_query = build_search_query(params)

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
                operator: "and",
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
                max_expansions: 10,
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
                operator: "and",
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

    if [full_name_query, content_query].any?
      search_query = []
      search_query << build_full_name_query(full_name_query) if full_name_query.present?
      search_query << build_content_query(content_query) if content_query.present?

      search_query
    end
  end
end
