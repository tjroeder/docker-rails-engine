require 'rails_helper'

RSpec.describe 'Merchant Items API', type: :request do
  describe '#index action' do
    let!(:merch) { create(:merchant) }
    let!(:items) { create_list(:item, 3, merchant: merch) }
    let!(:unused_item) { create(:item) }

    it 'returns a successful status' do
      get api_v1_merchant_items_path(merch)

      expect(response).to have_http_status(200)
    end


    it 'returns a list of all items for specific merchant' do
      get api_v1_merchant_items_path(merch)
      items = json_parse

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(3)

      items[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        expect(item[:id]).not_to eq(unused_item.id)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:name]).not_to eq(unused_item.name)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).not_to eq(unused_item.description)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:unit_price]).not_to eq(unused_item.unit_price)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
        expect(item[:attributes][:merchant_id]).not_to eq(unused_item.unit_price)
      end
    end

    it 'returns an array of data even if no items' do
      no_item_merch = create(:merchant)
      get api_v1_merchant_items_path(no_item_merch)
      items = json_parse

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].empty?).to eq(true)
    end

    it 'returns merchant not found if it does not exist' do
      last_merchant = Merchant.last
      get api_v1_merchant_items_path(last_merchant.id + 1)
      
      expect(response).to have_http_status(404)
    end

    it 'returns a unsuccessful status if given string for merchant id' do
      merchant = create(:merchant)
      get api_v1_merchant_items_path('string')
      expect(response).to have_http_status(404)
    end
  end
end
