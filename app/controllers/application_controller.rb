class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :authenticate_user!

  def not_found(msg = 'Not found.')
    raise ActionController::RoutingError.new(msg)
  end

  def set_username(quoteStructure)
    if quoteStructure.respond_to?(:each)
      quoteStructure.each do |quote|
        quote.setUsername(User.find(quote.user_id).username)
      end
    else
      quoteStructure.setUsername(User.find(quoteStructure.user_id).username)
    end

  end
  def set_quote_dependents(quoteStructure)

    if quoteStructure.respond_to?(:each)

      quoteStructure.each do |quote|
        quote.setUsername(User.find(quote.user_id).username)
      end

    else
      quoteStructure.setUsername(User.find(quoteStructure.user_id).username)
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
