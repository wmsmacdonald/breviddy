class AddEmailToQuote < ActiveRecord::Migration
  def change
    add_column :bits, :email, :string
  end
end
