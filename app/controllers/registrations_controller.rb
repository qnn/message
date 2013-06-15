class RegistrationsController < Devise::RegistrationsController

  before_filter :list_of_roles, :only => [:update, :edit]

  def update
    if (User::ROLES.include? current_user.role) && (User::ROLES.include? params[:user][:role].to_s)
      old_pos = User::ROLES.index(current_user.role)
      new_pos = User::ROLES.index(params[:user][:role])
      if old_pos == 0 && new_pos != 0
        redirect_to :back, :alert => t("unauthorized.cannot_change_root") and return
      end
      if new_pos < old_pos
        redirect_to :back, :alert => t("unauthorized.cannot_change_role") and return
      end
    else
      params[:user][:role] = User::ROLES.last
    end
    super
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    super
  end

end
