class ApplicationMailer < ActionMailer::Base
  default from: ENV["email_name"]
  layout "mailer"
end
