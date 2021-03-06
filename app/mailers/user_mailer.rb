class UserMailer < ActionMailer::Base
  default from: ENV['MAIL_USERNAME']
  add_template_helper(RatecardsHelper)
  
  def send_pdf_of_quote(quote)
    @user = quote.user
    @ratecard = quote
    self.instance_variable_set(:@ratecard, quote)
    @sortCol = 6
    self.instance_variable_set(:@sortCol, 6)
    @sortDir = 'desc'
    self.instance_variable_set(:@sortDir, 'desc')
    @schools = quote.schools
    self.instance_variable_set(:@schools, quote.schools)
    
    attachments["proposal-#{@ratecard.quote_date.strftime('%Y-%m-%d')}.pdf"] = WickedPdf.new.pdf_from_string(
          render_to_string(pdf: "proposal", template: 'ratecards/show.pdf.haml')
        )
    self.instance_variable_set(:@lookup_context, nil)
    mail(:to => @user.email, :subject => "Your Recent Proposal from On-Campus Media", 
         :bcc => [ENV['BCC_EMAIL']] ) 
  end
end