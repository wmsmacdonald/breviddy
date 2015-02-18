class RenameQuotesToBits < ActiveRecord::Migration
  def self.up
    rename_table :quotes, :bits
  end
  def self.down
    rename_table :bits, :quotes
  end
end
