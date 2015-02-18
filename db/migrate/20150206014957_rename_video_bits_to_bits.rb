class RenameVideoBitsToBits < ActiveRecord::Migration
  def self.up
    rename_table :video_bits, :bits
  end
  def self.down
    rename_table :bits, :video_bits
  end
end
