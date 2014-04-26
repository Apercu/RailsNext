class SetLanguageController < ApplicationController
	def english
		I18n.locale = :en
		set_session_and_redirect
	end

	def chinese
		I18n.locale = :ch
		set_session_and_redirect
	end

	private
	def set_session_and_redirect
		session[:locale] = I18n.locale
		@user = User.find(current_user.id)
		@user.update_attribute(:lang, I18n.locale)
		redirect_to root_path
	end
end
