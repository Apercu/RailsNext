class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

	def forem_user
    	current_user
  	end

  	helper_method :forem_user

	@okay = Devise::LDAP::Adapter.get_ldap_param("bgronon", "city")

    protect_from_forgery with: :exception
    before_action :authenticate_user!, :except => [:set_language_english_path, :set_language_chinese_path]
	before_action :set_locale
    before_filter :configure_permitted_parameters, if: :devise_controller?

	private
	def set_locale
		if current_user
			I18n.locale = current_user.lang || session[:locale] || I18n.default_locale
		else
			I18n.locale = session[:locale] || I18n.default_locale
		end
		session[:locale] = I18n.locale
	end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) do |u|
            u.permit :login, :email, :password, :password_confirmation
        end
    end
end
