class V1::BaseController < ApplicationController
  SUPPORTED_REQUEST_TYPES = [Mime[:json].to_s].freeze

  before_action :validate_request_type!
  before_action :authenticate_user!
  before_action :authorize!

  def validate_request_type!
    head :bad_request and return unless SUPPORTED_REQUEST_TYPES.include?(request.headers["Content-Type"])
  end

  def current_user
    @current_user ||= User.find_by(uuid: current_user_uuid)
  end

  def current_device
    @current_device ||= (current_user.present? && current_user.devices.find_by(uuid: current_device_uuid))
  end

  def authenticate_user!
    unless current_user.present? && current_device.present? && current_device.auth_token == x_auth_token
      render json: { message: I18n.t("sessions.error.unauthenticated") }, status: :unauthorized and return
    end
  end

  def current_resource
    nil
  end

  def current_permission
    @current_permission ||= Permissions.permission_for(current_user)
  end

  def authorize!
    unless current_permission.allow?(params[:controller], params[:action], current_resource)
      render json: { message: I18n.t("sessions.error.unauthorized") }, status: :unauthorized and return
    end
  end

  def get_pagiation_options
    @page = (params[:page].presence && params[:page].to_i >= 1) ? params[:page].to_i : 1
    @per_page = (params[:per_page].presence && params[:per_page].to_i >= 1) ? params[:per_page].to_i : 20

    @offset = (@page - 1) * @per_page
    @limit = @per_page
  end

  private

  def x_api_key
    @x_api_key ||= request.headers["X-API-KEY"]
  end

  def x_auth_token
    @x_auth_token ||= request.headers["Authorization"]
  end

  def jwt_payload
    begin
      @jwt_payload ||= x_api_key.present? && JWT.decode(x_api_key, JWT_SECRET)
    rescue JWT::DecodeError => ex
      logger.debug "----- #{ex.class.name} : #{ex.message} -----"
      @jwt_payload = nil
    end
  end

  def current_user_uuid
    jwt_payload.presence && jwt_payload[0].presence && jwt_payload[0]["user_id"]
  end

  def current_device_uuid
    jwt_payload.presence && jwt_payload[0].presence && jwt_payload[0]["device_id"]
  end
end
