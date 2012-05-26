class Post < ActiveRecord::Base
  attr_accessible :title, :description, :location, :status, :views
  before_save :set_as_pending, :generate_tags

  validates :title,       presence: true
  validates :description, presence: true
  validates :location,    presence: true

  belongs_to :user


  def set_as_pending
    self.status = 'pending'
  end

  def generate_tags
    words = location.split(',')
    provinces = []
    words.each { |w| w.include?('ken') ? provinces << w.downcase : next }
    self.tags = provinces
  end

end
