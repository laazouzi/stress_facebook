class CreateExceptionLogs < ActiveRecord::Migration
  def self.up
    create_table :exception_logs do |t|
      t.text :message
      t.text :backtrace

      t.timestamps
    end
  end

  def self.down
    drop_table :exception_logs
  end
end
