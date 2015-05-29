class UserProfileController < ApplicationController
  # Get user-profile
  def index
    @user = current_user
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user }
    end
  end

  # GET user-profile/:id
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render 'index.html' }
      format.json { render json: @user }
    end
  end
end