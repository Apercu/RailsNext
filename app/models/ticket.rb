class Ticket < ActiveRecord::Base

	belongs_to :user
	serialize :comments, Array

end
