require 'development_mail_interceptor'

ActionMailer::Base.smtp_settings = {
  :address              => ENV['SMTP_ADDRESS'],
  :port                 => ENV['SMTP_PORT'],
  :domain               => ENV['MAIL_DOMAIN'],
  :user_name            => ENV['MAIL_USERNAME'],
  :password             => ENV['MAIL_PASSWORD'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
