class AddImageToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :image, :string
  end
end
