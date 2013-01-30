class AddCycleTypeToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :cycle_type, :string
  end
end
