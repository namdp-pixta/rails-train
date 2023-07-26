# frozen_string_literal: true

# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  default from: 'dangnamshuy@gmail.com'
  layout 'mailer'
end
