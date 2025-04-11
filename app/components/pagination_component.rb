# frozen_string_literal: true

class PaginationComponent < ViewComponent::Base
  include Pagy::Frontend

  def initialize(pagy:)
    @pagy = pagy
  end

  def series
    @pagy.series
  end

  def params_to_keep
    request.query_parameters.slice(:full_name, :content)
  end
end
