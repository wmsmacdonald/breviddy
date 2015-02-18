class BitsController < ApplicationController
  def new
  end
  before_filter :authenticate_user!,
                :only => [:new]
  def create
    @bit = current_user.bits.create(bit_params)

    if @bit.save
      redirect_to @bit
    else
      key, value = @bit.errors.messages.first
      redirect_to "/bits/new", alert: "Error: '#{key.capitalize}' field  #{value[0]}."
    end

  end

  def show
    @bits = Bit.find params[:id].split(',')
    set_bit_dependents(@bits)
    mute_cookie
  end

  def index
    if params[:search]
      @bits = Bit.search(params[:search])
    else
      @bits = Bit.paginate(page: params[:page]).order('created_at DESC')
      set_bit_dependents(@bits)
      respond_to do |format|
        format.html
        format.js
      end
    end
    mute_cookie
  end

  def user
    user = User.find_by_username(params[:username]) or not_found('User "'<<params[:username]<<'" not found')

    @bits = Bit.where({:user_id => user.id}).order(created_at: :desc)
    set_bit_dependents(@bits)
  end

  private
  def bit_params
    hash = params.require(:bit).permit(:url, :start, :title, :end, :urlId)
    begin
      hash[:urlId] = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(params[:bit].permit(:url)[:url])[1]
    rescue NoMethodError
      #do nothing
    end
    hash
  end

end
