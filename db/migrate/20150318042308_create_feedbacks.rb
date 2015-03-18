class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :enjoyment
      t.integer :design
      t.integer :ease_of_use
      t.string :bugs
      t.string :channel
      t.string :suggestions
      t.string :email

      t.timestamps
    end
  end
end
