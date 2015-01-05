class HomeController < ApplicationController

  def index
    if params[:search]
      @quotes = Quote.search(params[:search])
    else
      @quotes = Quote.all
      set_quote_dependents(@quotes)
    end

  end

end
