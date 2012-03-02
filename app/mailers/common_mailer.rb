class CommonMailer < ActionMailer::Base
  default 'Content-Transfer-Encoding' => 'UTF-8'

  protected
  def setup_email(email = 'alertize@gmail.com', options = {})
    sent_on Time.now
    mail_headers = {'X-Sender' => "support@alerti.com"}
    mail_headers = mail_headers.merge(options[:headers]) unless options[:headers].blank?
    headers(mail_headers)
    charset 'UTF-8'
    @recipients  = email
    @from        = options[:from] || "alertize@gmail.com"
    @subject     = "[DevAlerti] "
  end
end
