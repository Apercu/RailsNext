class ContactsController < ApplicationController
    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(params[:contact])
        @contact.request = request
        if @contact.deliver
            flash.now[:notice] = t(:tymessage)
        else
            flash.now[:error] = t(:errmessage)
            render :new
        end
    end
end
