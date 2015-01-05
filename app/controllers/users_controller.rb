class UsersController < ApplicationController
  def show
    user = User.find_by_username(params[:username]) or not_found('User "'<<params[:username]<<'" not found')

    @quotes = Quote.where({:user_id => user.id})
    set_quote_dependents(@quotes)
  end
end