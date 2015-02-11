class AddUserIdToQuotes < ActiveRecord::Migration
  def change
    add_column :bits, :user_id, :integer
  end
end
