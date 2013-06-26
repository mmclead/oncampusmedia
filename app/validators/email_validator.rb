require 'mail'
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    begin
      m = Mail::Address.new(value)
      # We must check that value contains a domain and that value is an email address
      r = m.domain && m.address == value
      t = m.__send__(:tree)
      list = ENV['ALLOWED_EMAILS'].split(",")
      puts "the list is #{list}"
      on_the_list = list.include? m.domain 
      puts "this email is on the list: #{on_the_list}"
      # We need to dig into treetop
      # A valid domain must have dot_atom_text elements size > 1
      # user@localhost is excluded
      # treetop must respond to domain
      # We exclude valid email values like <user@localhost.com>
      # Hence we use m.__send__(tree).domain
      r &&= (t.domain.dot_atom_text.elements.size > 1) && on_the_list
      
      puts "final result = #{r}"
      
    rescue Exception => e   
      r = false
    end
    record.errors[attribute] << (options[:message] || "is invalid") unless r
  end
end