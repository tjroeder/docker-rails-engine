require 'rails_helper'

RSpec.describe 'Merchants API', type: :request do
  describe '#index action' do
    it 'returns a successful status' do
      create_list(:merchant, 3)
      get api_v1_merchants_path

      expect(response).to have_http_status(200)
    end

    it 'returns a list of all merchants' do
      create_list(:merchant, 3)
      get api_v1_merchants_path
      merchants = json_parse

      expect(merchants).to be_a(Hash)
      expect(merchants[:data]).to be_a(Array)
      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('merchant')

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'returns an array of data even if no merchants' do
      get api_v1_merchants_path
      merchants = json_parse

      expect(merchants).to be_a(Hash)
      expect(merchants[:data]).to be_a(Array)
      expect(merchants[:data].empty?).to eq(true)
    end

    it 'returns an array of data if one merchant' do
      create(:merchant)
      get api_v1_merchants_path
      merchants = json_parse

      expect(merchants).to be_a(Hash)
      expect(merchants[:data]).to be_a(Array)
      expect(merchants[:data].count).to eq(1)
      expect(merchants[:data].empty?).to eq(false)
    end

    it 'does not include dependent data' do
      create_list(:merchant, 3)
      get api_v1_merchants_path
      merchants = json_parse

      merchants[:data].each do |merchant|
        expect(merchant).to_not have_key(:relationships)
      end
    end
  end

  describe '#show action' do
    it 'returns a successful status if found' do
      merchant = create(:merchant)
      get api_v1_merchant_path(merchant)

      expect(response).to have_http_status(200)
    end

    it 'returns a unsuccessful status if not found' do
      merchant = create(:merchant)
      get api_v1_merchant_path(merchant.id + 1)

      expect(response).to have_http_status(404)
    end

    it 'returns a unsuccessful status if given string for merchant id' do
      merchant = create(:merchant)
      get api_v1_merchant_path('string')

      expect(response).to have_http_status(404)
    end

    it 'returns a merchants data' do
      merchant = create(:merchant)
      get api_v1_merchant_path(merchant)
      merch_parsed = json_parse
      
      expect(merch_parsed).to be_a(Hash)
      expect(merch_parsed[:data]).to be_a(Hash)
      
      expect(merch_parsed[:data]).to have_key(:id)
      expect(merch_parsed[:data][:id]).to be_an(String)

      expect(merch_parsed[:data]).to have_key(:type)
      expect(merch_parsed[:data][:type]).to eq('merchant')

      expect(merch_parsed[:data][:attributes]).to have_key(:name)
      expect(merch_parsed[:data][:attributes][:name]).to be_a(String)
    end

    it 'does not include dependent data' do
      merchant = create(:merchant)
      get api_v1_merchant_path(merchant)
      merch_parsed = json_parse

      expect(merch_parsed[:data]).to_not have_key(:relationships)
    end
  end
end
