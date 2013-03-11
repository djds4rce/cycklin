class AddSizesToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :sizes, :integer, :array=>true
  end
end
