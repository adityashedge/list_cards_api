class V1::CommentsController < V1::BaseController
  before_action :load_commentable
  before_action :validate_commentable!, except: [:update, :destroy]

  def index
    get_pagiation_options
    comments = @commentable.comments.order(:comment_id)
    total_comments = comments.count
    comments = comments.offset(@offset).limit(@limit)

    render json: {
      data: { total_comments: total_comments, comments: comments.as_json(only: [:uuid, :description, :comments_count]) },
      page: @page,
      per_page: @per_page
    }, status: :ok
  end

  def create
    comment = @commentable.comments.build(comment_params)
    comment.user = current_user
    if comment.save
      render json: {
        message: I18n.t("active_record.success.created", record: "Comment"),
        data: { comment: comment.as_json(only: [:uuid, :description, :comments_count]) },
      }, status: :created
    else
      render json: {
        message: I18n.t("active_record.error.not_created", record: "comment"),
        errors: comment.errors
      }, status: :unprocessable_entity
    end
  end

  def show
    head :bad_request and return unless @commentable.is_a?(Comment)

    comments = @commentable.comments.order(:comment_id)

    comment_data = @commentable.as_json(only: [:uuid, :description, :comments_count])
    comment_data.merge!(replies: comments.as_json(only: [:uuid, :description, :comments_count]))
    render json: { data: { comment: comment_data } }, status: :ok
  end

  def update
    render json: { message: I18n.t("active_record.error.not_found", record: "Comment") }, status: :not_found and return unless current_resource.present?

    comment = current_resource
    comment.assign_attributes(comment_params)
    if comment.save
      render json: {
        message: I18n.t("active_record.success.updated", record: "Comment"),
        data: { comment: comment.as_json(only: [:uuid, :description, :comments_count]) },
      }, status: :ok
    else
      render json: {
        message: I18n.t("active_record.error.not_updated", record: "comment"),
        errors: comment.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: { message: I18n.t("active_record.error.not_found", record: "Comment") }, status: :not_found and return unless current_resource.present?

    comment = current_resource
    if comment.destroy
      render json: {
        message: I18n.t("active_record.success.deleted", record: "Comment"),
      }, status: :ok
    else
      render json: {
        message: I18n.t("active_record.error.not_deleted", record: "comment"),
        errors: comment.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def load_commentable
    @commentable ||= if params[:resource_type] == "cards"
                       Card.find_by(uuid: params[:resource_id])
                     elsif params[:resource_type] == "comments"
                       Comment.find_by(uuid: params[:resource_id])
                     else
                       nil
                     end
  end

  def validate_commentable!
    head :bad_request and return unless ["cards", "comments"].include?(params[:resource_type])

    render json: { message: I18n.t("active_record.error.not_found", record: params[:resource_type].singularize.titleize) }, status: :not_found and return unless @commentable.present?
  end

  def current_resource
    @current_resource ||= if params[:action] == "update"
                            current_user.comments.find_by(uuid: params[:id])
                          elsif params[:action] == "destroy"
                            if current_user.is_admin?
                              Comment.find_by(uuid: params[:id])
                            else
                              current_user.comments.find_by(uuid: params[:id])
                            end
                          else
                            load_commentable
                          end
  end

  def comment_params
    params[:comment].permit(:description)
  end
end
