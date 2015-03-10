class BitsController < ApplicationController
  def new
  end

  #before_filter :authenticate_user!,
  #              :only => [:new]
  def create

    if user_signed_in?
      @bit = current_user.bits.create(signed_in_bit_params)
    else
      @bit = Bit.create(signed_out_bit_params)
    end

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

      @bits = Bit.paginate(page: params[:page]).order('created_at DESC')
      set_bit_dependents(@bits)
      respond_to do |format|
        format.html
        format.js
      end

    mute_cookie
  end

  def search
    @bits = Bit.search(params[:search]).order('created_at DESC')
    set_bit_dependents(@bits)
    mute_cookie
  end

  def user
    user = User.find_by_username(params[:username]) or not_found('User "'<<params[:username]<<'" not found')

    @bits = Bit.where({:user_id => user.id}).order(created_at: :desc)
    set_bit_dependents(@bits)
  end

  private
  def signed_in_bit_params
    hash = params.require(:bit).permit(:url, :start, :title, :end, :urlId)
    begin
      hash[:urlId] = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(params[:bit].permit(:url)[:url])[1]
    rescue NoMethodError
      #do nothing
    end
    hash
  end

  def signed_out_bit_params
    hash = params.require(:bit).permit(:url, :start, :title, :end, :urlId)
    begin
      hash[:urlId] = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(params[:bit].permit(:url)[:url])[1]
    rescue NoMethodError
      #do nothing
    end
    hash[:user_id] = '0'
    hash
  end

end
