class RegistrationsController < Devise::RegistrationsController

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
      redirect_to :back, :alert => t("unauthorized.default") and return
    end
    super
  end

  def new
    super
  end

  def edit
    if User::ROLES.include? current_user.role
      index = User::ROLES.index(current_user.role)
      if index == 0
        @roles = User::ROLES.take(1)
      else
        @roles = User::ROLES.drop(index)
      end
    else
      @roles = User::ROLES.last(1)
    end
  end

  def create
    super
  end

end
