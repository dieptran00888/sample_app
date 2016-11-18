class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @user = User.find_by id: params[:user_id]
    if @user.nil?
      redirect_to root_path
      flash[:danger] = "User not found"
    else
      relationship = params[:relationship]
      @title = relationship
      @users = @user.send(relationship).paginate page: params[:page]
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    unless current_user.following? @user
      current_user.follow @user
      @relationship = current_user.active_relationships.find_by followed_id: @user_id
    end
      redirect_to @user
  end

  def destroy
    @relationship = Relationship.find_by id: params[:id]
    if @relationship
      @user = @relationship.followed
        current_user.unfollow @user
      @relationship = current_user.active_relationships.build
    end
    redirect_to @user
  end
end
