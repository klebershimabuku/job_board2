# == Schema Information
#
# Table name: contact_infos
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#
class ContactInfo < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user
  validates :title,         presence: true
  validates :description,   presence: true
end


