class UserMailer < ApplicationMailer
  default from: 'welcome_notification@example.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome!')
  end
end
