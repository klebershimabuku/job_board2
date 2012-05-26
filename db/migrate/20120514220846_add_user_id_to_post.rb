class AddUserIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :user_id, :integer, nil: false
  end
end
