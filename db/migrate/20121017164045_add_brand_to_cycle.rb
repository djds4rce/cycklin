class AddBrandToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :brand, :string
  end
end
