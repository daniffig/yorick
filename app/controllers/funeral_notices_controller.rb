class FuneralNoticesController < ApplicationController
  def index
    full_name_query = params[:full_name].to_s.strip
    content_query = params[:content].to_s.strip

    notices = FuneralNotice.all

    if full_name_query.present?
      notices = notices.where("full_name ILIKE ?", "%#{full_name_query}%")
    end

    if content_query.present?
      notices = notices.where("content ILIKE ?", "%#{content_query}%")
    end

    notices = notices.order(published_on: :desc)

    @pagy, @funeral_notices = pagy(notices)
  end
end
