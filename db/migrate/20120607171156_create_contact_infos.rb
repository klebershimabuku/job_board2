class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.string :title
      t.string :description
      t.integer :user_id, nil: false
      t.timestamps
    end
  end
end
