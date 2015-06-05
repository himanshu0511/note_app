unless %w(test development).member?(Rails.env)
  email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email_settings.yml"))
  ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?
end