class UserMailer < ActionMailer::Base
  default from: ENV['MAIL_USERNAME']
  add_template_helper(RatecardsHelper)
  
  def send_pdf_of_quote(quote)
    @user = quote.user
    @ratecard = quote
    attachments["proposal-#{@ratecard.quote_date.strftime('%Y-%m-%d')}.pdf"] = WickedPdf.new.pdf_from_string(
          render_to_string(pdf: "proposal", template: 'ratecards/show.pdf.haml')
        )
    self.instance_variable_set(:@lookup_context, nil)
    mail(:to => @user.email, :subject => "Your Recent Proposal from On-Campus Media", 
         :bcc => [ENV['BCC_EMAIL']] ) 
  end
end