class UsersController < ApplicationController

  before_filter :list_of_roles, :only => [:edit, :update]
  before_filter :list_of_roles2, :only => [:new, :create]

  def can_change_root?
    if current_user.role != User::ROLES[0]
      # deny viewing page
      not_found if @user.role == User::ROLES[0]
      # deny editing
      not_found if !params.nil? && params.has_key?(:user) && params[:user][:role] == User::ROLES[0]
    end
  end

  def is_myself?
    not_found if @user.id == current_user.id # yourself
  end

  def list_of_roles2
    if User::ROLES.include? current_user.role
      index = User::ROLES.index(current_user.role)
      if index == 0
        @roles = User::ROLES.drop(1)
      else
        @roles = User::ROLES.drop(index)
      end
    else
      @roles = User::ROLES.drop(1)
    end
  end

  def index
    if current_user.role == User::ROLES[0]
      @users = User.all(:order => "created_at ASC")
    else
      @users = User.where("role != ?", User::ROLES[0])
    end

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])
    can_change_root?

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
    can_change_root?
    @user.email = "example@qq.com" if @user.email.blank?
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(params[:user])
    can_change_root?
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: t("users.created") }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    is_myself?
    can_change_root?
  end

  def update
    @user = User.find(params[:id])
    is_myself?
    can_change_root?
    params[:user].delete :password if params[:user][:password].empty?
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: t("users.updated") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@user = User.find(params[:id])
    is_myself?
    can_change_root?
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: t("users.deleted") }
      format.json { head :no_content }
    end
  end

end
