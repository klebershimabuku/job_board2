# == Schema Information
#
# Table name: posts
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  location    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  status      :string(255)     default("pending")
#  tags        :string(255)
#  views       :integer(4)
#  user_id     :integer(4)
#
class Post < ActiveRecord::Base
  attr_accessible :title, :description, :location, :status, :views
  before_save :generate_tags
  after_update :set_as_pending, :generate_tags

  validates :title,       presence: true
  validates :description, presence: true
  validates :location,    presence: true

  belongs_to :user

  scope :approved_filter_by_tag, lambda { |tag| where("tags LIKE ? and status = ?", "%#{tag}%", "approved") }

  def self.expire_older_than_3_months
    where('created_at <= ?', 3.months.ago).each do |p|
      p.update_column(:status, 'expired')
    end
  end

  def self.available_tags
    provinces = []

    approved.select { |post| provinces << post.tags.split(',') }

    available_tags = provinces.flatten.uniq.sort!
  end

  def to_param
    "#{id}-#{title.downcase.parameterize}"
  end

  def self.approved
    where('status = ?', 'approved').order('created_at DESC')
  end

  def suspended?
    status == 'suspended'
  end

  def suspend!
    update_column(:status, 'suspended')
  end

  def set_as_pending
    update_column(:status, 'pending')
  end

  def generate_tags
    pattern = /(\w+-ken)/
    results = location.scan(pattern)
    self.tags = results.each { |x| x.to_s }.join(',').downcase
  end

end