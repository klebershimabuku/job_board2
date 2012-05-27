class Post < ActiveRecord::Base
  attr_accessible :title, :description, :location, :status, :views
  before_save :generate_tags
  after_update :set_as_pending

  validates :title,       presence: true
  validates :description, presence: true
  validates :location,    presence: true

  belongs_to :user

  scope :filter_by_tag, lambda { |tag| where("tags LIKE ? and status = ?", "%#{tag}%", "approved") }

  def self.approved
    where('status = ?', 'approved')
  end

  def set_as_pending
    self.status = 'pending'
  end

  def generate_tags
    words = location.split(',')
    provinces = []
    words.each { |w| w.include?('ken') ? provinces << w.downcase.strip : next }
    self.tags = provinces.join(',')
  end

end
