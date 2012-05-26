class AddStatusTagsViewsToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |p|
      p.string :status, default: 'pending'
      p.string :tags
      p.integer :views
    end
  end
end
