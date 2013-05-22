class UserMailer < ActionMailer::Base
  default from: "mason@chewysystems.com"
  add_template_helper(RatecardsHelper)
  
  def send_pdf_of_quote(quote)
    @user = quote.user
    @ratecard = quote
    @url  = "http://example.com/login"
    mail(:to => @user.email, :subject => "Your Recent Quote from On-Campus Media") do |format|
      format.html
      format.pdf do
        attachments["quote"] = WickedPdf.new.pdf_from_string(
          render_to_string(pdf: "quote", template: 'ratecards/show.pdf.haml')
        )
      end
    end
  end
  
end
