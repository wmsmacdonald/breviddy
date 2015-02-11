class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :authenticate_user!

  def not_found(msg = 'Not found.')
    raise ActionController::RoutingError.new(msg)
  end

  def set_username(bitStructure)
    if bitStructure.respond_to?(:each)
      bitStructure.each do |bit|
        bit.setUsername(User.find(bit.user_id).username)
      end
    else
      bitStructure.setUsername(User.find(bitStructure.user_id).username)
    end

  end
  def set_bit_dependents(bitStructure)

    if bitStructure.respond_to?(:each)

      bitStructure.each do |bit|
        bit.setUsername(User.find(bit.user_id).username)
      end

    else
      bitStructure.setUsername(User.find(bitStructure.user_id).username)
    end

  end

  def mute_cookie
    if cookies[:muted].blank?
      cookies[:muted] = true
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

end
