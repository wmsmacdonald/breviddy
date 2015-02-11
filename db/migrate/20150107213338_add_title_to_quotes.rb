class AddTitleToQuotes < ActiveRecord::Migration
  def change
    add_column :bits, :title, :string
  end
end
