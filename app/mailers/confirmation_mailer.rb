# frozen_string_literal: true

class ConfirmationMailer < ApplicationMailer
  default from: ENV['EMAIL']
  def confirm_email
    @nominator = params[:nominator]
    @student = params[:student]
    mail(to: @nominator.nominator_email)
  end
end
