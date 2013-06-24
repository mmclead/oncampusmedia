if Rails.env.staging? || Rails.env.production?
  WickedPdf.config = {
    :exe_path => Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s,
    :dpi => '300',
    :orientation => 'Portrait',
    :page_size  => "Letter",
    :page_height => '5in', 
    :page_width => '7in'
  }
else
  WickedPdf.config = {
    :exe_path => '/usr/local/bin/wkhtmltopdf',
    :dpi => '300',
    :page_size  => "Letter",
  }
end
  