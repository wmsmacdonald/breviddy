class UserMailer < Devise::Mailer

 default from: "confirmation@breviddy.com"

 def feedback_alert(feedback)
   @feedback = feedback
   mail(to: 'wmsmacdonald@gmail.com', subject: 'New feedback for Breviddy')
 end

end

