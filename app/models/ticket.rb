class Ticket < ActiveRecord::Base

	belongs_to :user
	serialize :comments

end
