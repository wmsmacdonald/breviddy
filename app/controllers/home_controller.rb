class HomeController < ApplicationController
  def index
    if params[:search]
      @quotes = Quote.search(params[:search])
    else
      @quotes = Quote.all
      @quotes.each do |quote|
        quote.setUsername(User.find(quote.user_id).username)
      end
    end

  end

end
