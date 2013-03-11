class Cycle < ActiveRecord::Base
  include Firefox
  include Decathlon
  mount_uploader :image, ImageUploader
  attr_accessible :age, :brand, :price, :cycle_type, :url, :name, :image, :flag, :front_suspension, :rear_suspension, :suspension, :frame, :sizes
  
  default_scope where(:flag=>true)
 
  scope :by_brand, lambda {|brand| return if brand.blank?
    where(brand: brand)}

  scope :by_type, lambda {|type| return if type.blank?
    where(cycle_type: type)}
  
  scope :by_age, lambda {|age| return if age.blank?
    where(age: age)}

  def self.search params
    return Cycle if params.blank?
    Cycle.by_brand(params[:brand])
    .by_type(params[:type])
    .by_age(params[:age])
  end

  def self.scrape
    Cycle.update_all('flag = false')
    Cycle.create_data(Firefox.scrape)
    Cycle.create_data(Decathlon.scrape)
  end
  
  def self.create_data data
    data.each do |item|
      db_item = Cycle.find_by_name(item[:name])
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
