class ConfirmationMailer < ApplicationMailer
  default from: ENV['EMAIL']
  def confirm_email
	@nominator = params[:nominator]
	@student = params[:student]
	mail(to: @nominator.nominator_email, subject:'Form Confirmation')
  end
end
