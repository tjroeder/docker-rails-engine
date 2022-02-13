class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items, dependent: :destroy

  validates :name, :description, :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0 }

  scope :find_all_by_name, ->(sel_name) { where('items.name ILIKE ?', "%#{sel_name}%") }

  # Class Methods
  def self.max_min_price(max: nil, min: nil)
    if max.nil? || min.nil?
      where('items.unit_price <= ? OR items.unit_price >= ?', max, min)
    else
      where('items.unit_price <= ? AND items.unit_price >= ?', max, min)
    end
  end
end
