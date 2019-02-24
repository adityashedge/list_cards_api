class V1::CardsController < V1::BaseController
  def index
    get_pagiation_options
    cards = current_user.cards.order(comments_count: :desc, card_id: :desc)
    total_cards = cards.count
    cards = cards.offset(@offset).limit(@limit)

    render json: {
      data: { total_cards: total_cards, cards: cards.as_json(only: [:uuid, :title, :description, :comments_count]) },
      page: @page,
      per_page: @per_page
    }, status: :ok
  end

  def create
    head :bad_request and return unless params[:card].present? && params[:card][:list_id].present?

    list = if current_user.is_admin?
             List.find_by(uuid: params[:card][:list_id])
           else
             current_user.lists.find_by(uuid: params[:card][:list_id])
           end
    render json: { message: I18n.t("active_record.error.not_found", record: "List") }, status: :not_found and return unless list.present?

    card = list.cards.build(card_params)
    card.user = current_user
    if card.save
      render json: {
        message: I18n.t("active_record.success.created", record: "Card"),
        data: { card: card.as_json(only: [:uuid, :title, :description, :comments_count]) },
      }, status: :created
    else
      render json: {
        message: I18n.t("active_record.error.not_created", record: "card"),
        errors: card.errors
      }, status: :unprocessable_entity
    end
  end

  def show
    render json: { message: I18n.t("active_record.error.not_found", record: "Card") }, status: :not_found and return unless current_resource.present?

    card = current_resource
    # latest cards with most comments first
    comments = card.comments.includes(:user).order(:created_at).limit(3)
    card_data = card.as_json(only: [:uuid, :title, :description, :comments_count])
    card_data.merge!(comments: comments.as_json(only: [:uuid, :description], include: { user: { only: [:uuid, :name, :user_type] } }))
    render json: { data: { card: card_data } }, status: :ok
  end

  def update
    render json: { message: I18n.t("active_record.error.not_found", record: "Card") }, status: :not_found and return unless current_resource.present?

    card = current_resource
    card.assign_attributes(card_params)
    if card.save
      render json: {
        message: I18n.t("active_record.success.updated", record: "Card #{card.title}"),
        data: { card: card.as_json(only: [:uuid, :title, :description, :comments_count]) },
      }, status: :ok
    else
      render json: {
        message: I18n.t("active_record.error.not_updated", record: "card #{card.title}"),
        errors: card.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: { message: I18n.t("active_record.error.not_found", record: "Card") }, status: :not_found and return unless current_resource.present?

    card = if current_user.is_admin?
             Card.where(list_id: current_user.owned_list_ids, uuid: params[:id]).first
           else
             current_user.cards.find_by(uuid: params[:id])
           end
    if card.destroy
      render json: {
        message: I18n.t("active_record.success.deleted", record: "Card #{card.title}"),
      }, status: :ok
    else
      render json: {
        message: I18n.t("active_record.error.not_deleted", record: "card #{card.title}"),
        errors: card.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params[:card].permit(:title, :description)
  end

  def current_resource
    @current_resource ||= if current_user.is_admin?
                            Card.find_by(uuid: params[:id])
                          else
                            current_user.cards.find_by(uuid: params[:id])
                          end
  end
end
