class UsersController < ApplicationController
  def me
    @quotes = Quote.where({:email => current_user.email})
  end
  def show
    user = User.find_by_username(params[:username]) or not_found('User "'<<params[:username]<<'" not found')

    @quotes = Quote.where({:user_id => user.id})
  end
end