class AddFrameToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :frame, :string
  end
end
