class ApplicationController < ActionController::Base
  include Pagy::Backend
  helper Pagy::Frontend
end
