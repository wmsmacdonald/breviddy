class DeleteEmailFromQuotes < ActiveRecord::Migration
  def change
    remove_column :quotes, :email
  end
end
