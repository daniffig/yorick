class FuneralNoticesController < ApplicationController
  def index
    full_name_query = params[:full_name].to_s.strip
    content_query = params[:content].to_s.strip

    if full_name_query.present? || content_query.present?
      conditions = []
      values = {}

      if full_name_query.present?
        conditions << "full_name ILIKE :full_name"
        values[:full_name] = "%#{full_name_query}%"
      end

      if content_query.present?
        conditions << "content ILIKE :content"
        values[:content] = "%#{content_query}%"
      end

      @funeral_notices = FuneralNotice
        .where(conditions.join(" AND "), values)
        .order(published_on: :desc)
        .page(params[:page])
        .per(20)
    else
      @funeral_notices = []
    end
  end
end
