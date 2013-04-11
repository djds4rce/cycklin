class Cycle < ActiveRecord::Base
  include Firefox
  include Decathlon
  mount_uploader :image, ImageUploader
  attr_accessible :id, :age, :brand, :price, :cycle_type, :url, :name, :image, :flag, :front_suspension, :rear_suspension, :suspension, :frame, :sizes
  
  default_scope where(:flag=>true)
 
  scope :by_brand, lambda {|brand| return if brand.blank?
    where(brand: brand)}

  scope :by_type, lambda {|type| return if type.blank?
    where(cycle_type: type)}
  
  scope :by_age, lambda {|age| return if age.blank?
    where(age: age)}
  
  scope :by_price, lambda{|max_price, min_price| return if max_price.blank?|| min_price.blank?
  where("price <= ? AND price >= ?",max_price, min_price)  
  }
  def self.search params
    return Cycle.order("price asc") if params.blank?
    Cycle.by_brand(params[:brand])
    .by_type(params[:type])
    .by_age(params[:age])
    .by_price(params[:max_price], params[:min_price]).order("price asc")
  end

  def self.scrape
    Cycle.update_all('flag = false')
    Cycle.create_data(Firefox.scrape)
    Cycle.create_data(Decathlon.scrape)
    Cycle.create_data(TrackAndTrail.scrape)
  end
  
  def self.create_data data
    data.each do |item|
      db_item = Cycle.unscoped.find_by_name(item[:name])
      item[:flag] = true
      image = item.delete(:image)
      begin
      if db_item.nil?
       db_item = Cycle.create(item)
      else
        db_item.update_attributes(item)
      end
      db_item.remote_image_url = image
      db_item.save
      rescue
      end
    end
  end

  def get_image_path 
    "/public/#{self.image}"
  end
end
