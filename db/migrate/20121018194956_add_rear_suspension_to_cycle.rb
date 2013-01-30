class AddRearSuspensionToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :rear_suspension, :string
  end
end
