class AddSizesToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :sizes, :string
  end
end
