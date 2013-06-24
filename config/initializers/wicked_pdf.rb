if Rails.env.staging? || Rails.env.production?
  WickedPdf.config = {
    :exe_path => Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s,
    :dpi => '300',
    :orientation => 'Portrait',
    :page_height => '11in', 
    :page_width => '8in'
  }
else
  WickedPdf.config = {
    :exe_path => '/usr/local/bin/wkhtmltopdf',
    :dpi => '300',
    :orientation => 'Portrait',
    :page_height => '11in', 
    :page_width => '8in'
  }
end
  