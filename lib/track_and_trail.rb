module TrackAndTrail

  def self.scrape 
    urls = { "Road" => "http://www.trackandtrail.in/search.asp?style=road&team=&you=", "BMX" => "http://www.trackandtrail.in/search.asp?style=bmx&team=&you=" , "Hybrid" => "http://www.trackandtrail.in/search.asp?style=hybrid&team=&you=", "MTB" => "http://www.trackandtrail.in/search.asp?style=mtb&team=&you="}
    items = []
    urls.each_pair do |type, url|
      item_page = Nokogiri::HTML(open(url))
      item_page.xpath("//td[@class='brandheading']").map{|brand|
        brand_name = brand.text.strip
        brand.parent.next_element.css(".proheading table").children.xpath("td/a/@href").map{|product|
          href = with_base_uri product.value
          page = Nokogiri::HTML(open(with_base_uri(href)))
          items << get_details(page , {:url => href, :type => type, :brand=> brand_name})
        }
      }
    end
    items
  end

  def self.get_details page, params = {}
    item_hash = {}
    item_hash[:age] = "Adult"
    item_hash[:brand] = params[:brand]
    item_hash[:price] = page.xpath("//span[@class='pricered']").text.match(/[0-9,.]*/).to_s
    item_hash[:cycle_type] = params[:type]
    item_hash[:url] = params[:url]
    item_hash[:name] = page.xpath("//h1[@class='proheading']").text
    item_hash[:image] = with_base_uri( page.xpath("//img[contains(@id,'product_spec_image')]/@src").text )
    item_hash
  end


  def self.with_base_uri uri
    URI.join("http://www.trackandtrail.in/",uri).to_s
  end

end
