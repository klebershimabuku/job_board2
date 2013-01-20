# == Schema Information
#
# Table name: posts
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  description  :text
#  location     :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  status       :string(255)     default("pending")
#  tags         :string(255)
#  views        :integer
#  user_id      :integer
#  published_at :datetime
#  expired_at   :datetime
#

class Post < ActiveRecord::Base
  attr_accessible :title, :description, :location, :status, :views
  before_save :generate_tags
  after_update :set_as_pending, :generate_tags

  validates :title,       presence: true
  validates :description, presence: true
  validates :location,    presence: true, valid_province: true

  belongs_to :user

  scope :published_filter_by_tag, lambda { |tag| where("tags LIKE ? and status = ?", "%#{tag}%", "published") }
  scope :pendings, where('status = ?', 'pending')
  scope :expireds, where('status = ?', 'expired')
  scope :publisheds, where('status = ?', 'published')

  def self.expire_older_than_3_months
    where('created_at <= ?', 3.months.ago).each do |p|
      p.expire!
    end
  end

  def self.available_tags
    provinces = []

    published.select { |post| provinces << post.tags.split(',') }

    available_tags = provinces.flatten.uniq.sort!
  end

  def to_param
    "#{id}-#{title.downcase.parameterize}"
  end

  def self.published
    where('status = ?', 'published').order('published_at DESC')
  end
  
  def publish!
    update_column(:status, 'published')
    update_column(:published_at, Time.now)

    publish_on_facebook
  end
  
  def published?
    status == 'published'
  end

  def publish_on_facebook
    link = "http://www.shigotodoko.com/posts/#{id}"
    
    Facebook.publish(title, link, description[0..289])
  end
  
  def expire!
    update_column(:status, 'expired')
    update_column(:expired_at, Time.now)
  end
  
  def expired?
    status == 'expired'
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
    results = location.downcase.scan(pattern)
    self.tags = results.each { |x| x.to_s }.join(',').downcase
  end

end