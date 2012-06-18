class Company < ActiveRecord::Base
  attr_accessible :address, :description, :name, :prefecture_ids
  has_and_belongs_to_many :prefectures
  validates :name, :address, :description, presence: true
end
