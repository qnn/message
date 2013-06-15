class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def list_of_roles
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
end
