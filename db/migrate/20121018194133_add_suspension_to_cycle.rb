class AddSuspensionToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :suspension, :string
  end
end
