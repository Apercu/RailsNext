class TicketsController < ApplicationController

	before_action :set_ticket, only: [:show, :edit, :update, :destroy]

	# GET /tickets
	# GET /tickets.json
	def index
		if (current_user.level > 0)
			@tickets = Ticket.all
		else
			user = User.find(current_user.id)
			@tickets = user.tickets
		end
	end

	# GET /tickets/1
	# GET /tickets/1.json
	def show
		tik = Ticket.find(params[:id])
		if (!(current_user.level > 0 || tik.user_id == current_user.id))
            flash[:error] = "You are not authorized to view that page."
            redirect_to root_path
		end
	end

	# GET /tickets/new
	def new
		@ticket = Ticket.new
	end

	# GET /tickets/1/edit
	def edit
	end

	# POST /tickets
	# POST /tickets.json
	def create

		user = User.find(current_user.id)
		@ticket = Ticket.new(ticket_params)
		@ticket.user = user
		@ticket.status = "open"
		@ticket.assigned_to = 5

		respond_to do |format|
			if @ticket.save
				format.html { redirect_to @ticket, notice: t('ticketcreated') }
				format.json { render :show, status: :created, location: @ticket }
			else
				format.html { render :new }
				format.json { render json: @ticket.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /tickets/1
	# PATCH/PUT /tickets/1.json
	def update
		tik = Ticket.find(params[:id])
		if (current_user.level > 0 || tik.user_id == current_user.id)
			if (params[:comment].length > 0)
				@ticket.comments.push({"user" => current_user.login, "content" => params[:comment], "time" => Time.now.strftime("%H:%M:%S %Y-%d-%m") })
			end
			if (params[:assigned_to] && params[:assigned_to].is_number?)
				@ticket.assigned_to = params[:assigned_to].to_i
			end
			respond_to do |format|
				if @ticket.update(ticket_update_params)
					format.html { redirect_to @ticket, notice: t('ticketupdated') }
					format.json { render :show, status: :ok, location: @ticket }
				else
					format.html { render :edit }
					format.json { render json: @ticket.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# DELETE /tickets/1
	# DELETE /tickets/1.json
	def destroy
	end

	def is_number
		true if Float(self) rescue false
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_ticket
		@ticket = Ticket.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def ticket_params
		params.require(:ticket).permit(:title, :content, :comments, :status, :user_id, :assigned_to)
	end

	def ticket_update_params
		params.require(:ticket).permit(:comment, :status, :assigned_to)
	end
end
