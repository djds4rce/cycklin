class AddPriceToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :price, :integer
  end
end
