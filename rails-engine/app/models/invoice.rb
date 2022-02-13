class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items, dependent: :destroy

  validates :status, presence: true
end
