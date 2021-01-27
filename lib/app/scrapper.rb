require 'bundler'
Bundler.require

class Scrapper
  attr_accessor :doc
  attr_accessor :site_url

  def initialize(site_url)
    @doc = Nokogiri::HTML(URI.open(site_url))
    @site_url = site_url
  end

  def get_mail
    pages = Nokogiri::HTML(URI.open(@site_url))
    mail = pages.xpath('//section[2]//tr[4]/td[2]').text
    return mail
  end
  
  def get_url
    @doc = Nokogiri::HTML(URI.open(@site_url + "val-d-oise.html"))
    towns = @doc.xpath('//*[@class="lientxt"]')
    townhall = Array.new
    
    towns.each do |city|
      towns_emails = Hash.new
      temp = city['href'].delete_prefix('./')
      towns_emails[city.text] = get_townhall_email("#{site_url}#{temp}")
      townhall << towns_emails
    end
    return townhall
  end

  def save_as_spreadsheet(array_to_store)
    array_to_store = Array.new
    # Creates a session with api google
    session = GoogleDrive::Session.from_config("config.json")

    # First worksheet of
    # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("t1SeSynifwcmS6c_Z9OgQCgT").worksheets[0] #!!!!!!!-======DON'T FORGET TO CHANGE THE KEY!!!!!!
    # OK pour moi ws = session.spreadsheet_by_title("test_sh").worksheets.first

    # Changes content of cells.
    # Changes are not sent to the server until you call ws.save().
    array_to_store.each do | row |
      p row
      ws.insert_rows(1,row)
    end
    ws.save
    # Reloads the worksheet to get changes by other clients.
    ws.reload
  end

  def save_as_json(array_to_store)
    array_to_store = Array.new
    File.open("emails.json","w") do |f|
      f.write(JSON.pretty_generate(array_to_store))
    end
    system('mv emails.json db/emails.json')
  end
  
  def get_townhall_email(townhall_URL)
    page = Nokogiri::HTML(URI.open(townhall_URL))
    email = page.xpath('//main//section[2]//div//table//tbody//tr[4]/td[2]').text
    return email
  end

  def get_townhall_urls
    page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
    cities = page.xpath('//*[@class="lientxt"]')

    ary_result = [] # init arrray
    
    cities.each do |city|
        h_cities_email = {} #init hash
        temp = city['href'].delete_prefix('./')
        h_cities_email[city.text] = get_townhall_email("http://annuaire-des-mairies.com/#{temp}")
        ary_result << h_cities_email
    end
    return ary_result
  end
end
