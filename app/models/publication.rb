class Publication < ActiveRecord::Base
  belongs_to :archive
  validates :archive, presence: true

  validates :biuletyn, presence: true
  validates :pozycja, presence: true
  validates :data_publikacji, presence: true

  validates :pozycja, uniqueness: true, scope: :data_publikacji

  serialize :properties, Hash

  def name
    "[#{data_publikacji.try(:year).inspect}] #{data_publikacji}/#{pozycja} #{nazwa}"
  end
end
