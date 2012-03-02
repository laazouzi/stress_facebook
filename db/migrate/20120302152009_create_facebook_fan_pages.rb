class CreateFacebookFanPages < ActiveRecord::Migration
  def self.up
    create_table :facebook_fan_pages do |t|
      t.string :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_fan_pages
  end
end
