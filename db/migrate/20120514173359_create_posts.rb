class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, nil: false
      t.text :description, nil: false
      t.string :location, nil: false
      t.timestamps
    end
  end
end
