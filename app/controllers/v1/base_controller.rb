class V1::BaseController < ApplicationController
  SUPPORTED_REQUEST_TYPES = [Mime[:json].to_s].freeze

  before_action :validate_request_type!

  def validate_request_type!
    head :bad_request and return unless SUPPORTED_REQUEST_TYPES.include?(request.headers["Content-Type"])
  end
end
