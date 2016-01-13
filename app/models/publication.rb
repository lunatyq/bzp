class Publication < ActiveRecord::Base
  belongs_to :archive
  validates :archive, presence: true

  validates :biuletyn, presence: true
  validates :pozycja, presence: true
  validates :data_publikacji, presence: true
end
