class V1::SessionsController < V1::BaseController
  skip_before_action :authenticate_user!, except: [:destroy]
  skip_before_action :authorize!

  def create
    unless (params[:user].present? && params[:user][:login].present? && params[:user][:password].present? && params[:user][:device_identifier].present?)
      head :bad_request and return
    end

    user = User.where(["lower(username) = :value OR lower(email) = :value", { :value => params[:user][:login].downcase }]).first
    if user.present? && user.authenticate(params[:user][:password])
      device = user.devices.find_or_initialize_by(device_identifier: params[:user][:device_identifier])
      device.generate_auth_token
      device.update_tracked_fields(request)
      if device.save
        user_data = user.as_json(only: [:uuid, :name, :email, :username, :user_type])
        user_data.merge!(api_key: user.api_key(device), device: device.as_json(only: [:uuid, :device_identifier, :auth_token]))
        render json: {
          message: I18n.t('sessions.success.signed_in'),
          data: { user: user_data }
        }, status: :ok
      else
        render json: { message: I18n.t('sessions.error.device_not_saved') }, status: :unprocessable_entity
      end
    else
      render json: { message: I18n.t('sessions.error.sign_in') }, status: :unprocessable_entity
    end
  end

  def destroy
    current_device.auth_token = nil
    current_device.update_attribute(:auth_token, nil)
    render json: { message: I18n.t('sessions.success.signed_out') }, status: :ok
  end
end
