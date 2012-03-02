class CreateFacebookAccounts < ActiveRecord::Migration
  def self.up
    create_table :facebook_accounts do |t|
      t.string :token, :null => false
    end
  end

  def self.down
    drop_table :facebook_accounts
  end
end
