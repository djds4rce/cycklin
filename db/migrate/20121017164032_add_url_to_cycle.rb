class AddUrlToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :url, :string
  end
end
