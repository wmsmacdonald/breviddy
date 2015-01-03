class QuotesController < ApplicationController
  def new
  end
  before_filter :authenticate_user!,
                :only => [:new]
  def create
    @quote = current_user.quotes.create(quote_params)

    @quote.save
    redirect_to @quote
  end

  def show
    @quote = Quote.find(params[:id])
  end

  def index
    not_found('No page here.')
  end

  def search
    @quotes = Quote.search params[:search]
  end

  private
  def quote_params
    hash = params.require(:quote).permit(:url, :start, :caption, :end)
    #hash[:email] = current_user.email
    hash
  end

end
