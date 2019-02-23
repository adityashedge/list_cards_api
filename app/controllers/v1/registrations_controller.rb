class V1::RegistrationsController < V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :authorize!

  def create
    head :bad_request and return unless (params[:user].present? && params[:user][:device_identifier].present?)

    user = User.new(user_params)
    user.update_tracked_fields(request)
    if user.save
      device = user.devices.build(device_identifier: params[:user][:device_identifier])
      device.generate_auth_token
      device.update_tracked_fields(request)
      if device.save
        user_data = user.as_json(only: [:uuid, :name, :email, :username, :user_type])
        user_data.merge!(api_key: user.api_key(device), device: device.as_json(only: [:uuid, :device_identifier, :auth_token]))
        render json: {
          message: I18n.t('registrations.success.signed_up'),
          data: { user: user_data }
        }, status: :created
      else
        render json: {
          message: I18n.t('registrations.success.signed_up'),
          data: {
            user: user.as_json(only: [:uuid, :name, :email, :username, :user_type])
          }
        }, status: :created
      end
    else
      render json: {
        message: I18n.t('registrations.error.sign_up'),
        errors: user.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params[:user].permit(:name, :email, :username, :user_type, :password, :password_confirmation)
  end
end
