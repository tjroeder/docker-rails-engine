require 'rails_helper'

RSpec.describe 'Item Merchant API', type: :request do
  describe '#index action' do
    let!(:merch) { create(:merchant) }
    let!(:item) { create(:item, merchant: merch) }
    let!(:unused_merch) { create(:merchant) }

    it 'returns a successful status' do
      get api_v1_item_merchant_index_path(item)

      expect(response).to have_http_status(200)
    end

    it 'returns a merchant for a specific item' do
      get api_v1_item_merchant_index_path(item)
      merchant = json_parse

      expect(merchant).to be_a(Hash)
      expect(merchant[:data]).to be_a(Hash)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_an(String)
      expect(merchant[:data][:id]).not_to eq(unused_merch.id)

      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to eq('merchant')

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:attributes][:name]).not_to eq(unused_merch.id)
    end

    it 'returns item not found if it does not exist' do
      get api_v1_item_merchant_index_path(item.id + 1)
      
      expect(response).to have_http_status(404)
    end
  end
end