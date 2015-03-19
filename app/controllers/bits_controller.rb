class BitsController < ApplicationController
  include BitsHelper
  before_action :mute_cookie

  def new
  end

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
  end

  def index
    @bits = Bit.paginate(page: params[:page]).order('created_at DESC')
    set_bit_dependents(@bits)
    respond_to do |format|
      format.html
      format.js
    end

  end

  def search
    @bits = Bit.search(params[:search]).order('created_at DESC')
    set_bit_dependents(@bits)
  end

  def user
    user = User.find_by_username(params[:username]) or not_found('User "'<<params[:username]<<'" not found')

    @bits = Bit.where({:user_id => user.id}).order(created_at: :desc)
    set_bit_dependents(@bits)
  end

  def destroy
    Bit.destroy(params[:id])
    redirect_to '/'
    flash[:notice] = "Video bit was successfully deleted."
  end

end
