class V1::ListsController < V1::BaseController
  before_action :load_member, only: [:assign_member, :unassign_member]

  def index
    get_pagiation_options
    if current_user.is_admin?
      lists = current_user.owned_lists.order(:list_id)
    else
      lists = current_user.lists.order(:list_id)
    end
    total_lists = lists.count
    lists = lists.offset(@offset).limit(@limit)

    render json: {
      data: { total_lists: total_lists, lists: lists.as_json(only: [:uuid, :title]) },
      page: @page,
      per_page: @per_page
    }, status: :ok
  end

  def create
    head :unauthorized and return unless current_user.is_admin?

    list = current_user.owned_lists.build(list_params)
    if list.save
      render json: {
        message: I18n.t("active_record.success.created", record: "List"),
        data: { list: list.as_json(only: [:uuid, :title]) }
      }, status: :created
    else
      render json: {
        message: I18n.t("active_record.error.not_created", record: "list"),
        errors: list.errors
      }, status: :unprocessable_entity
    end
  end

  def show
    render json: { message: I18n.t("active_record.error.not_found", record: "List") }, status: :not_found and return unless current_resource.present?

    list = current_resource
    render json: {
      data: { list: list.as_json(only: [:uuid, :title]) }
    }, status: :ok
  end

  def update
    head :unauthorized and return unless current_user.is_admin?
    render json: { message: I18n.t("active_record.error.not_found", record: "List") }, status: :not_found and return unless current_resource.present?

    list = current_resource
    list.assign_attributes(list_params)
    if list.save
      render json: {
        message: I18n.t("active_record.success.updated", record: "List #{list.title}"),
        data: { list: list.as_json(only: [:uuid, :title]) }
      }, status: :ok
    else
      render json: {
        message: I18n.t("active_record.error.not_updated", record: "list #{list.title}"),
        errors: list.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    head :unauthorized and return unless current_user.is_admin?
    render json: { message: I18n.t("active_record.error.not_found", record: "List") }, status: :not_found and return unless current_resource.present?

    list = current_resource
    if list.destroy
      render json: {
        message: I18n.t("active_record.success.deleted", record: "List #{list.title}"),
      }, status: :ok
    else
      render json: {
        message: I18n.t("active_record.error.not_deleted", record: "list #{list.title}"),
        errors: list.errors
      }, status: :unprocessable_entity
    end
  end

  def assign_member
    head :unauthorized and return unless current_user.is_admin?
    render json: { message: I18n.t("active_record.error.not_found", record: "List") }, status: :not_found and return unless current_resource.present?
    render json: { message: I18n.t("active_record.error.not_found", record: "Member user") }, status: :not_found and return unless @member.present?

    list = current_resource
    if list.users.exists?(@member.user_id)
      render json: {
        message: I18n.t("active_record.error.already_exists", record: "Member user", parent: "list #{list.title}")
      }, status: :unprocessable_entity and return
    end

    if list.users.push(@member)
      render json: { message: I18n.t("active_record.success.added", record: "Member user", parent: "list #{list.title}") }, status: :ok and return
    else
      render json: {
        message: I18n.t("active_record.success.not_added", record: "member user", parent: "list #{list.title}")
      }, status: :unprocessable_entity and return
    end
  end

  def unassign_member
    head :unauthorized and return unless current_user.is_admin?
    render json: { message: I18n.t("active_record.error.not_found", record: "List") }, status: :not_found and return unless current_resource.present?
    render json: { message: I18n.t("active_record.error.not_found", record: "Member user") }, status: :not_found and return unless @member.present?

    list = current_resource
    unless list.users.exists?(@member.user_id)
      render json: {
        message: I18n.t("active_record.error.does_not_exist", record: "Member user", parent: "list #{list.title}")
      }, status: :unprocessable_entity and return
    end

    if list.users.destroy(@member)
      render json: { message: I18n.t("active_record.success.removed", record: "Member user", parent: "list #{list.title}") }, status: :ok and return
    else
      render json: {
        message: I18n.t("active_record.success.not_removed", record: "member user", parent: "list #{list.title}")
      }, status: :unprocessable_entity and return
    end
  end

  private

  def list_params
    params[:list].permit(:title)
  end

  def current_resource
    @current_resource ||= if current_user.is_admin?
                            current_user.owned_lists.find_by(uuid: params[:id])
                          else
                            current_user.lists.find_by(uuid: params[:id])
                          end
  end

  def load_member
    @member = User.find_by(uuid: params[:member_id], user_type: User::MEMBER_USER_TYPE)
  end
end
