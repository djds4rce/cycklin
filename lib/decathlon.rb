module Decathlon

  def self.scrape 
    urls = { "kids" => "http://www.decathlon.in/index.php?route=module/filter/getsearchproducts&search=categories&path=5&page=", "mountain" => "http://www.decathlon.in/mountain-bikes" , "city" => "http://www.decathlon.in/City-bikes", "trekking" => "http://www.decathlon.in/trekking-bikes", "road" => "http://www.decathlon.in/road-bikes" , "folding" => "http://www.decathlon.in/folding-bikes", "bmx" => "http://www.decathlon.in/cycling-bmx" }
    items = []
    urls.each_pair do |type, url|
      kids_page_count = 1
      if type == "kids"
        while true
          item_page = Nokogiri::HTML(open(url+kids_page_count.to_s))
          item_page.css(".article").each do |article|
            href = article.css("a").last["href"]
            page = Nokogiri::HTML(open(href))
            desc = get_product_description_hash page
            next if desc["brakes"].nil?
            items << get_details(page , {:desc => desc, :url => href, :type => type})
          end
          kids_page_count += 1
          break if kids_page_count == 4 
        end
      else
        item_page = Nokogiri::HTML(open(url))
        item_page.css(".article").each do |article|
          href = article.css("a").last["href"]
          page = Nokogiri::HTML(open(href))
          desc = get_product_description_hash page
          items << get_details(page , {:desc => desc, :age => "adult", :url => href, :type => type})
        end
      end
    end
    puts items
    puts items.length
    items
  end

  def self.get_details page, params = {}
    item_hash = {}
    item_hash[:age] = params[:desc]["age_range"].strip.downcase 
    begin
      item_hash[:frame] = params[:desc]["frame"].strip
      item_hash[:suspension] = params[:desc]["suspension"].strip
    rescue
    end
    item_hash[:brand] = "dechatlon"
    item_hash[:price] = page.css(".t-price").first.text.split(":").last.strip.gsub(",","")
    item_hash[:cycle_type] = params[:type]
    item_hash[:url] = params[:url]
    item_hash[:name] = page.css(".product_title").first.text.strip
    item_hash[:image] = page.css(".product-image img").first["src"]
    item_hash
  end


  def self.get_product_description_hash page
    desc = {}
    page.css(".prod-description4").each do |feature|
      split_feature = feature.text.split(":")
      desc[split_feature[0].strip.scrape_underscore] = split_feature[1]
    end
    desc
  end

end
