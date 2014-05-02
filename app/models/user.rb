class User < ActiveRecord::Base

  has_many :tickets

  devise :ldap_authenticatable, :rememberable, :trackable

  def forem_name
	  login
  end

  def forem_email
	  email
  end

end
