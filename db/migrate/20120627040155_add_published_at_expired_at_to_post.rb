class AddPublishedAtExpiredAtToPost < ActiveRecord::Migration
  def change
    add_column :posts, :published_at, :datetime, nil: true
    add_column :posts, :expired_at, :datetime, nil: true
  end
end
