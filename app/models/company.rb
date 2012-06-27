# == Schema Information
#
# Table name: companies
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  address     :text
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Company < ActiveRecord::Base
  attr_accessible :address, :description, :name, :prefecture_ids
  has_and_belongs_to_many :prefectures
  validates :name, :address, :description, presence: true
end

