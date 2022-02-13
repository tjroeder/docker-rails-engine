require 'rails_helper'

RSpec.describe 'Merchants Search API', type: :request do
  describe '#find action' do
    let!(:merch1) { create(:merchant, name: 'Turing') }
    let!(:merch2) { create(:merchant, name: 'aRing World') }
    let!(:merch3) { create(:merchant, name: 'Abc') }
    let!(:merch4) { create(:merchant, name: 'Boringo') }

    it 'returns a successful status if found' do
      get find_api_v1_merchants_path, params: { name: 'ring' }

      expect(response).to have_http_status(200)
    end

    it 'returns a successful status if merchant is not found' do
      get find_api_v1_merchants_path, params: { name: 'zzzzyyz' }

      expect(response).to have_http_status(200)
    end

    it 'returns 400 status if no param is given' do
      get find_api_v1_merchants_path

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if no param value is given' do
      get find_api_v1_merchants_path, params: { name: '' }

      expect(response).to have_http_status(400)
    end

    it 'returns a specific merchants data using a search name' do
      get find_api_v1_merchants_path, params: { name: 'ring' }
      merch_parsed = json_parse
      
      expect(merch_parsed).to be_a(Hash)
      expect(merch_parsed[:data]).to be_a(Hash)
      
      expect(merch_parsed[:data]).to have_key(:id)
      expect(merch_parsed[:data][:id]).to eq(merch4.id.to_s)

      expect(merch_parsed[:data]).to have_key(:type)
      expect(merch_parsed[:data][:type]).to eq('merchant')

      expect(merch_parsed[:data][:attributes]).to have_key(:name)
      expect(merch_parsed[:data][:attributes][:name]).to eq(merch4.name)
    end

    it 'returns blank data if no merchant found matching search name' do
      get find_api_v1_merchants_path, params: { name: 'zzzzyyz' }
      merch_parsed = json_parse
      
      expect(merch_parsed).to be_a(Hash)
      expect(merch_parsed[:data]).to be_a(Hash)
      
      expect(merch_parsed[:data]).not_to have_key(:id)
      expect(merch_parsed[:data]).not_to have_key(:type)
      expect(merch_parsed[:data]).not_to have_key(:attributes)
    end
  end
end
