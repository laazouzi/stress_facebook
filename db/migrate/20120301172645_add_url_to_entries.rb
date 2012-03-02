class AddUrlToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :url, :text
  end

  def self.down
    remove_column :entries, :url
  end
end
