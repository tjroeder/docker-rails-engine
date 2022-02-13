require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe 'factory' do
    it 'can create a factory with name, description, unit_price and merchant' do
      item = create(:item, name: 'Taco', description: 'Street style al pastor taco', unit_price: 1.75)

      expect(item).to be_valid
      expect(item).to be_a(Item)
      expect(item).to have_attributes(name: 'Taco')
      expect(item).to have_attributes(description: 'Street style al pastor taco')
      expect(item).to have_attributes(unit_price: 1.75)
      expect(item.merchant).to be_a(Merchant)
    end
  end

  describe 'class methods' do
    describe '::find_all_by_name' do
      it 'returns items that case insensitive match name fragment' do
        item1 = create(:item, name: 'Turing')
        item2 = create(:item, name: 'aRing World')
        item3 = create(:item, name: 'Abc')
        item4 = create(:item, name: 'Boringo')
        expected = [item1, item2, item4]

        expect(Item.find_all_by_name('Ring')).to eq(expected)
        expect(Item.find_all_by_name('ring')).to eq(expected)
        expect(Item.find_all_by_name('RING')).to eq(expected)
        expect(Item.find_all_by_name('rInG')).to eq(expected)
      end
    end
    
    describe '::max_min_price' do
      it 'returns items with unit_price less than or equal to max price' do
        item1 = create(:item, unit_price: 10.00)
        item2 = create(:item, unit_price: 10.01)
        item3 = create(:item, unit_price: 12.00)
        item4 = create(:item, unit_price: 3.50)
        expected = [item1, item4]
        
        expect(Item.max_min_price(max: '10.00')).to eq(expected)
      end
      
      it 'returns items with unit_price greater than or equal to min price' do
        item1 = create(:item, unit_price: 10.00)
        item2 = create(:item, unit_price: 10.01)
        item3 = create(:item, unit_price: 12.00)
        item4 = create(:item, unit_price: 3.50)
        expected = [item1, item2, item3]
        
        expect(Item.max_min_price(min: '10.00')).to eq(expected)
      end

      it 'returns items with unit_price between max and min price' do
        item1 = create(:item, unit_price: 10.00)
        item2 = create(:item, unit_price: 10.01)
        item3 = create(:item, unit_price: 12.00)
        item4 = create(:item, unit_price: 3.50)
        expected = [item1, item2]

        expect(Item.max_min_price(max: '11.00', min: '6.50')).to eq(expected)
      end
    end
  end

  # describe 'instance methods' do
  #   describe '#destroy_empty_invoice' do
  #     it 'destroys the invoice_item after destroying the item' do
  #       item = create(:item)
  #       invoice_items = create_list(:invoice_item, 3, item: item)
  #       invoice1 = invoice_items[0].invoice
  #       invoice2 = invoice_items[1].invoice
  #       invoice3 = invoice_items[2].invoice
  #       invoice_item = create(:invoice_item, invoice: invoice2)
        

  #       expect(item).to be_present
  #       expect(invoice1).to be_present
  #       expect(invoice2).to be_present
  #       expect(invoice3).to be_present
  #       require 'pry'; binding.pry
  #       item.destroy

  #       expect{ Item.find(item.id) }.to raise_error
  #       expect{ InvoiceItem.find(item.invoice_items) }.to raise_error
  #       # expect(item).not_to be_present
  #       # expect(invoice_item).not_to be_present
  #       # expect(invoice).not_to be_present
  #     end
  #   end
  # end
end
