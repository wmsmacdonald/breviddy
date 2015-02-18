class RenameVideoBitsToQuotes < ActiveRecord::Migration
  def change
    def self.up
      rename_table :bits, :quotes
    end
    def self.down
      rename_table :quotes, :bits
    end
  end
end
