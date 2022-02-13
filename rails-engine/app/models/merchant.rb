class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def self.find_one_by_name(sel_name)
    where('merchants.name ILIKE ?', "%#{sel_name}%").order(:name).first
  end
end
