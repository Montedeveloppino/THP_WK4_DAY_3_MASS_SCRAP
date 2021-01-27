class Scrapper
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'
  $principal_adress="http://annuaire-des-mairies.com"
  @array_name = Array.new
  @array_mail = Array.new
  
  
  def scrapper
      return doc = Nokogiri::HTML(URI.open('http://annuaire-des-mairies.com/val-d-oise.html'))
   end
  
  def city_mail
      page_city = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/44/nantes.html"))
      mail_city = page_city.xpath('//html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]')
      name_city = page_city.xpath('//html/body/div[1]/main/section[1]/div/div/div/h1')
  
      m_city = mail_city.text
      n_city = name_city.text
  
      mon_hash = Hash[n_city, m_city]
  
      puts mon_hash
  end
  
   def get_mail(array_final,array_link)
     puts "It takes time"
       array_link.each{|link|
       pages=Nokogiri::HTML(URI.open($principal_adress+link))
       mail = pages.xpath('//section[2]//tr[4]/td[2]').text
       array_final << mail
       }
       return array_final
   end
   
   def fusiontab(tab1,tab2)
       return Hash[tab1.zip(tab2)]
   end
   
   def mairie(page)
       array_of_mail=[]
       array_of_link=[]
       array_of_name=[]
  
       links=page.xpath('//tr//td//p[1]//a')
  
       links.each{|link|
           array_of_name<<link.text
       }
       array_of_name.delete("Plan du site")
       links.each{|link|
       array_of_link<<link['href']
       }
      array_of_link.delete("plan-du-site.html")
       for i in 0..array_of_link.length-1
           array_of_link[i][0]=array_of_link[i][0].delete(".")
       end
       get_mail(array_of_mail,array_of_link)
       hash=fusiontab(array_of_name,array_of_mail)
       return hash
   end
  print city_mail()
  print mairie(scrapper)
end
