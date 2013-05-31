class UserMailer < ActionMailer::Base
  default from: ENV['MAIL_USERNAME']
  add_template_helper(RatecardsHelper)
  
  def send_pdf_of_quote(quote)
    @user = quote.user
    @ratecard = quote
    attachments["proposal.pdf"] = WickedPdf.new.pdf_from_string(
          render_to_string(pdf: "proposal", template: 'ratecards/show.pdf.haml')
        )
    mail(:to => @user.email, :subject => "Your Recent Proposal from On-Campus Media") 

  end
  
end
