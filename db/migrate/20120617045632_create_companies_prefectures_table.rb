class CreateCompaniesPrefecturesTable < ActiveRecord::Migration
 def self.up
    create_table :companies_prefectures, :id => false do |t|
        t.references :company
        t.references :prefecture
    end
  end

  def self.down
    drop_table :companies_prefectures
  end
end
