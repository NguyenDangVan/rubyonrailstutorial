class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailers.email_default
  layout "mailer"
end
