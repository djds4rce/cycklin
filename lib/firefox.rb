module Firefox

def self.scrape
  url = "http://www.firefoxbikes.com/"
  items = []
  home_page = Nokogiri::HTML(open(url))
  home_page.css(".flexdropdownmenu li").each do |menu_item|
    menu_link = menu_item.css("a").first["href"]
    menu_text = menu_item.css("h1").first.text
    next if menu_text == "TREK" || menu_text == "GARY FISHER" 
    type = get_type(menu_text)
    menu_page = Nokogiri::HTML(open(url+menu_link))
    if menu_page.css(".fullsuspension_categari_text_mouseshow").length == 0
      menu_page.css(".fullsuspension_categari_text a").each do |item|
        item_page = Nokogiri::HTML(open(url+item["href"]))
        items << get_details(item_page, { :type => type, :url => item["href"]})
      end
    elsif type == "kids"
      menu_page.css(".fullsuspension_categari_text_mouseshow").each do |item|
        href = item.css("a").first["href"]
        begin
          item_page = Nokogiri::HTML(open(url+href))
          age = item.parent.previous_element.text.split(" ")[1]
        rescue
          next
        end
        items << get_details(item_page, {:type => type, :age => age, :url => href})
      end 
    else
      menu_page.css(".fullsuspension_categari_text_mouseshow").each do |item|
        href = item.css("a").first["href"]
        begin
          item_page = Nokogiri::HTML(open(url+href))
          brand = item.parent.previous_element.text.scrape_underscore
        rescue
          next
        end
        items << get_details(item_page, {:type => type, :brand => brand, :url=> href})
      end 

    end
  end
  puts items.compact!
  puts items.length
  items
end


def self.get_details item_page, params = {}
  item_hash = {}
  item_hash[:cycle_type] = params[:type]
  item_hash[:brand] = params[:brand] || "firefox"
  item_hash[:age] = params[:age].nil? ? "adult" : "junior"
  item_hash[:price] = item_page.css(".mrp_text").first.text.strip.split("INR")[1].gsub(",","")
  item_hash[:url] = "http://firefoxbikes.com/"+params[:url]
  begin
    item_hash[:name] =  item_page.css(".product_name h2").first.text
  rescue
    return
  end

  begin
    item_hash[:image] = "http://www.firefoxbikes.com/"+item_page.css("#product_image1 img").first["src"]
  rescue
    item_hash[:image] = "http://www.firefoxbikes.com/"+item_page.css("#product_image1").first.next_sibling["src"]
  end

  spec_details = item_page.css(".detail_text ul").first
  spec_details.css("span").each do |spec|
    split_spec = spec.text.split(":")
    item_hash[split_spec[0].strip.scrape_underscore.to_sym] = split_spec[1] 
  end
  item_hash
end

def self.get_type menu_text
  case menu_text

  when "FULL SUSPENSION"
    return "mountain"

  when "HARDTAIL"
    return "mountain"

  else
    return menu_text.downcase
  end
end

end
