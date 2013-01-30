class String
  def scrape_underscore 
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      gsub(' ','_').
      tr("-", "_").
      downcase
  end
end


