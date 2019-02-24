class V1::UsersController < V1::BaseController
  def index
    head :unauthorized unless current_user.is_admin?

    page = (params[:page].presence && params[:page].to_i >= 1) ? params[:page].to_i : 1
    per_page = (params[:per_page].presence && params[:per_page].to_i >= 1) ? params[:per_page].to_i : 20

    offset = (page - 1) * per_page
    limit = per_page

    users = User.where(user_type: User::MEMBER_USER_TYPE).order(:user_id)
    total_users = users.count
    users = users.offset(offset).limit(limit)
    render json: {
      data: {
        total_users: total_users,
        users: users.as_json(only: [:uuid, :name, :email, :user_type])
      },
      page: page,
      per_page: per_page
    }, status: :ok
  end
end
