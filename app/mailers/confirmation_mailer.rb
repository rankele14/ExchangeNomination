class ConfirmationMailer < ApplicationMailer
  default from: 'tamuexchangenomination@gmail.com'
  def confirm_email
	@representative = params[:representative]
	@student = params[:student]
	mail(to: @representative.rep_email, subject:'Form Confirmation')
  end
end
