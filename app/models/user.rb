class User < ActiveRecord::Base

  has_many :tickets

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def forem_name
	  login
  end

  def forem_email
	  email
  end

end
