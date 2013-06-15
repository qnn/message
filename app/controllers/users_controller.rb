class UsersController < ApplicationController

  before_filter :list_of_roles, :only => [:edit, :update]

  def index
    @users = User.all(:order => "created_at DESC")

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
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
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: t("users.deleted") }
      format.json { head :no_content }
    end
  end

end
