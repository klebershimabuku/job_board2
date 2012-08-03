class AddUserIdToPost < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.references :user_id
    end
  end
  
  def self.down
    change_table :posts do |t|
      t.references :user_id
    end
  end
end
