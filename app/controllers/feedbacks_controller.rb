class FeedbacksController < ApplicationController

  respond_to :html


  def new
    @feedback = Feedback.new
    respond_with(@feedback)
  end


  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.save
    flash[:notice] = "Thank you for the feedback! I will use it to make this website better."
    redirect_to '/'
  end


  private
    def feedback_params
      params.require(:feedback).permit(:enjoyment, :design, :ease_of_use, :bugs, :channel, :suggestions, :email)
    end
end
