class AddFlagToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :flag, :boolean
  end
end
