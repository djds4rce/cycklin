class AddFrontSuspensionToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :front_suspension, :string
  end
end
