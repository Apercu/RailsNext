class ApplicationController < ActionController::Base

	def forem_user
    	current_user
  	end

  	helper_method :forem_user

    protect_from_forgery with: :exception
    before_action :authenticate_user!
	before_action :set_locale
    before_filter :configure_permitted_parameters, if: :devise_controller?

	private
	def set_locale
		I18n.locale = session[:locale]|| I18n.default_locale
		session[:locale] = I18n.locale
	end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) do |u|
            u.permit :login, :email, :password, :password_confirmation
        end
    end
end
