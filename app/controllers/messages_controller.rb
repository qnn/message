class MessagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]

  # GET /messages
  # GET /messages.json
  def index
    if User::ROLES.first(User::AdminThreshold).include? current_user.role
      @messages = Message.all
    else
      @messages = Message.where("visible_to = 0 OR visible_to = ?", current_user.id).order("created_at DESC")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    if User::ROLES.first(User::AdminThreshold).include? current_user.role
      @message = Message.find(params[:id])
    else
      @message = Message.where("id = ? AND (visible_to = 0 OR visible_to = ?)", params[:id], current_user.id).first
    end
    not_found if @message.nil?
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
    authorize! :update, @message
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to new_message_url, notice: t("messages.created") }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
    authorize! :update, @message
    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: t("messages.updated") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    authorize! :destroy, @message
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: t("messages.deleted") }
      format.json { head :no_content }
    end
  end
end
