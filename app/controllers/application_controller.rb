class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :exception

  after_filter :store_location

  #-----------------------------------------
  #Devise: Redirects user to previous URL after sign in and sign out

  def store_location 
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        !request.xhr? && # don't store ajax calls
        request.fullpath != "/users") 
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    #Small bug locally, when I sign_up it redirects to '/users' which doesnt exist;
    session[:previous_url] || home_path
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || home_path
  end

#-----------------------------------------
  #Devise: Adds additional permitted params to the devise user model
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password,
      :password_confirmation, :remember_me, :image, :image_cache) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password,
      :password_confirmation, :current_password, :image, :image_cache) }
  end
  #-----------------------------------------
end
