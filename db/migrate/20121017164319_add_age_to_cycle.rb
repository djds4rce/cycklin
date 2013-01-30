class AddAgeToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :age, :string
  end
end
