# frozen_string_literal: true

class ConfirmationMailer < ApplicationMailer
  default from: ENV['EMAIL']
  def confirm_email
    @representative = params[:representative]
    @student = params[:student]
    mail(to: @representative.rep_email, subject: 'Form Confirmation')
  end
end
