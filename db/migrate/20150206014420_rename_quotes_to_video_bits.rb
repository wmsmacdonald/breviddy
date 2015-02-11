class RenameQuotesToVideoBits < ActiveRecord::Migration
  def self.up
    rename_table :quotes, :video_bits
  end
  def self.down
    rename_table :video_bits
  end
end
