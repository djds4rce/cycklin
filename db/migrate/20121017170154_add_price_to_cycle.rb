class AddPriceToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :price, :string
  end
end
