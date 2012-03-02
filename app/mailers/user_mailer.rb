class UserMailer < CommonMailer
  layout 'user_mailer'
  
  def facebook_stats(email = 'alertize@gmail.com')
    setup_email(email)
    @subject += 'Statistique Facebook'
    mail(:to => @recipients, :from => @from, :subject => @subject)
  end
end
