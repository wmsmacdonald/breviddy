class AddUrlIdToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :urlId, :string
  end
end
