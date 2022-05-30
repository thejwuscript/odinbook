class UserMailer < ApplicationMailer
  default from: "welcome_notification@example.com"
  
  def welcome_email
    @user = params[:user]
    @url = 'http://localhost:3000'
    mail(to: @user.email, subject: 'Welcome!')
  end
end
