class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.string :title
      t.text :description
      t.references :user
      t.timestamps
    end
  end
end
