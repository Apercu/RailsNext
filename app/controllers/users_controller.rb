class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :authorized?
    def authorized?
        if (current_user.level < 1)
            flash[:error] = "You are not authorized to view that page."
            redirect_to root_path
        end
    end

    # GET /users
    # GET /users.json
    def index
        @users = User.all
    end

    # GET /users/1
    # GET /users/1.json
    def show
    end

    # GET /users/new
    def new
        @user = User.new
    end

    # GET /users/1/edit
    def edit
    end

    # POST /users
    # POST /users.json
    def create
        @user = User.new(user_params)

        respond_to do |format|
            if @user.save
                format.html { redirect_to @user, notice: t('usercreated') }
                format.json { render :show, status: :created, location: @user }
            else
                format.html { render :new }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update

        if user_params[:password].blank?
            user_params.delete(:password)
            user_params.delete(:password_confirmation)
        end

        user = User.find(params[:id])
        level = params[:level].to_i;
        successfully_updated = if needs_password?(@user, user_params)
                                   @user.update(user_params)
                               else
                                   @user.update_without_password(user_params)
                               end

        respond_to do |format|
            if successfully_updated
                format.html { redirect_to @user, notice: t('userupdated') }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
        user = User.find(params[:id])
        if (current_user == user)
            respond_to do |format|
                format.html { redirect_to users_url, notice: t('deleteyourself') }
                format.json { head :no_content }
            end
        else
            @user.destroy
            respond_to do |format|
                format.html { redirect_to users_url }
                format.json { head :no_content }
            end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:login, :email, :level, :password, :password_confirmation)
    end
    def needs_password?(user, params)
        params[:password].present?
    end

end
