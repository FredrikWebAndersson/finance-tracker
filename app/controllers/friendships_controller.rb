class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    if current_user.save
      flash[:notice] = "Now following user"
    else
      flash[:alert] = "There was something wrong with the request"
    end
    redirect_to friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first #Dont forget .first => we need to select the actual relationship. 
    friendship.destroy
    flash[:notice] = "Stopped following"
    redirect_to friends_path
  end
end
