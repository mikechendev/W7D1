class SessionsController < ApplicationController

    before_action :require_logged_out, only: [:new, :create]
    
    def new
        @user= User.new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
        if @user.nil?
            render :new
        else
            session[:session_token] = @user.reset_session_token!
            redirect_to cats_url
        end
    end

    def destroy
        if current_user
            current_user.reset_session_token!
        end
        session[:session_token] = nil
        redirect_to new_session_url
    end
end
