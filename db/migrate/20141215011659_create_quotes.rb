class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :url
      t.string :start
      t.string :caption
      t.string :end

      t.timestamps
    end
  end
end
