class AddNameToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :name, :string
  end
end
