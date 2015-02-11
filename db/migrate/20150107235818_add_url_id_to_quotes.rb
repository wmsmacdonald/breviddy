class AddUrlIdToQuotes < ActiveRecord::Migration
  def change
    add_column :bits, :urlId, :string
  end
end
