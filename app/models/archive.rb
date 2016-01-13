class Archive < ActiveRecord::Base
  validates :year, presence: true
  validates :published_on, presence: true
  validates_uniqueness_of :published_on, :scope => :year

  has_many :publications
end
