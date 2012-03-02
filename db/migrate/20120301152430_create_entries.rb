class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :http_code
      t.text :response_body

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
