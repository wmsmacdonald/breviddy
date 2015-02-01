class QuotesController < ApplicationController
  def new
  end
  before_filter :authenticate_user!,
                :only => [:new]
  def create
    @quote = current_user.quotes.create(quote_params)

    if @quote.save
      redirect_to @quote
    else
      key, value = @quote.errors.messages.first
      redirect_to "/quotes/new", alert: "Error: '#{key.capitalize}' field  #{value[0]}."
    end

  end

  def show
    @quote = Quote.find(params[:id])
    set_quote_dependents(@quote)
    mute_cookie
  end

  def index
    if params[:search]
      @quotes = Quote.search(params[:search])
    else
      @quotes = Quote.all
      set_quote_dependents(@quotes)
    end
    mute_cookie
  end

  def user
    user = User.find_by_username(params[:username]) or not_found('User "'<<params[:username]<<'" not found')

    @quotes = Quote.where({:user_id => user.id})
    set_quote_dependents(@quotes)
  end



  private
  def quote_params
    hash = params.require(:quote).permit(:url, :start, :caption, :end, :urlId)
    begin
      hash[:urlId] = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(params[:quote].permit(:url)[:url])[1]
    rescue NoMethodError
      #do nothing
    end
    hash
  end

end
