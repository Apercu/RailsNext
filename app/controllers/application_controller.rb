class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

	def forem_user
    	current_user
  	end

  	helper_method :forem_user

	require 'rubygems'
	require 'net/ldap'


	ldap = Net::LDAP.new(
		:host => 'ldap.42.fr',
		:port => 389
	)
	ldap.authenticate "cn=Balthazar\ GRONON", ""

	filter = Net::LDAP::Filter.eq("uid", "*")
	treebase = "dc=42, dc=fr"

	credentials = {
		:method => :simple,
		:username => "bgronon",
		:password => ""
	}

	Net::LDAP.open(:host => "ldap.42.fr", :port => 389, :encryption => false, :base => "DC=42,DC=fr", :auth => credentials) do |ldap|
		puts ""
		if (!ldap.bind)
			puts "OKAY"
		end
	end

	puts Devise::LDAP::Adapter.get_ldap_param("bgronon","")
	ldap.search(:base => treebase, :filter => filter) do |entry|
		puts "dn: #{entry.dn}"
		entry.each do |attribute, values|
			values.each do |value|
				"<tr>"
					"<td><img src='data:image/png;base64,#{value.picture}'></td>"
					"<td>#{value.uid}</td>"
					"<td>#{value.prenom}</td>"
					"<td>#{value.nom}</td>"
					"<td>#{value.mobile-phone}</td>"
				"</tr>"
			end
		end
	end
	p ldap.get_operation_result

	ldap = Net::LDAP.new(
		:host => "ldap.42.fr",
    	:port => "389",
    	:base => "DC=42,DC=fr",
    	:auth => {
    		:method => :simple,
    		:username => "bgronon",
    		:password => ""
    	})
	if (ldap.bind)
		puts ""
	end

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
