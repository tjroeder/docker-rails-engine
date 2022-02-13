FactoryBot.define do
  factory :invoice_item do
    sequence(:quantity)
    sequence(:unit_price)

    item
    invoice
  end
end
