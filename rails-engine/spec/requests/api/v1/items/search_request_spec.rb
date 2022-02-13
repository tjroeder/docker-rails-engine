require 'rails_helper'

RSpec.describe 'Items Search API', type: :request do
  describe '#find_all action' do
    let!(:item1) { create(:item, name: 'Turing', unit_price: 10.00) }
    let!(:item2) { create(:item, name: 'aRing World', unit_price: 10.01) }
    let!(:item3) { create(:item, name: 'Abc', unit_price: 12.00) }
    let!(:item4) { create(:item, name: 'Boringo', unit_price: 3.50) }

    it 'returns a success status if items are found with name' do
      get find_all_api_v1_items_path, params: { name: 'ring' }

      expect(response).to have_http_status(200)
    end

    it 'returns a success status if items are found with max price' do
      get find_all_api_v1_items_path, params: { max_price: 10.00 }

      expect(response).to have_http_status(200)
    end

    it 'returns a success status if items are found with min price' do
      get find_all_api_v1_items_path, params: { min_price: 10.00 }

      expect(response).to have_http_status(200)
    end

    it 'returns a success status if items are found with min and max price' do
      get find_all_api_v1_items_path, params: { max_price: 10.00, min_price: 3.75 }

      expect(response).to have_http_status(200)
    end

    it 'returns a success status if items are not found with name' do
      get find_all_api_v1_items_path, params: { name: 'zzzzyyz' }

      expect(response).to have_http_status(200)
    end

    it 'returns a success status if items are not found with max price' do
      get find_all_api_v1_items_path, params: { max_price: 3.00 }

      expect(response).to have_http_status(200)
    end

    it 'returns a success status if items are not found with min price' do
      get find_all_api_v1_items_path, params: { min_price: 15.00 }

      expect(response).to have_http_status(200)
    end

    it 'returns a success status if items are not found with max or min price' do
      get find_all_api_v1_items_path, params: { max_price: 3.00, min_price: 15.00 }

      expect(response).to have_http_status(200)
    end

    it 'returns 400 status if valid name, max and min param is given' do
      get find_all_api_v1_items_path, params: { name: 'ring', max_price: 10.00, min_price: 3.00 }

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if valid name, max  param is given' do
      get find_all_api_v1_items_path, params: { name: 'ring', max_price: 10.00 }

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if valid name, min  param is given' do
      get find_all_api_v1_items_path, params: { name: 'ring', min_price: 10.00 }

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if not valid name, max and min param is given' do
      get find_all_api_v1_items_path, params: { name: '', max_price: 3.00, min_price: 15.00 }

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if no param is given' do
      get find_all_api_v1_items_path

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if no param value is given' do
      get find_all_api_v1_items_path, params: { name: '' }

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if max value is negative' do
      get find_all_api_v1_items_path, params: { max_price: -2.50 }

      expect(response).to have_http_status(400)
    end

    it 'returns 400 status if min value is negative' do
      get find_all_api_v1_items_path, params: { min_price: -3.50 }

      expect(response).to have_http_status(400)
    end

    it 'returns items data matching search name' do
      get find_all_api_v1_items_path, params: { name: 'ring' }
      items = json_parse

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(3)

      items[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:name]).to match(/ring/i)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
    
    it 'returns items data matching max price' do
      get find_all_api_v1_items_path, params: { max_price: 10.00 }
      items = json_parse
      
      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(2)
      
      items[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        
        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:unit_price]).to be <= 10.00
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
    
    it 'returns items data matching min price' do
      get find_all_api_v1_items_path, params: { min_price: 10.00 }
      items = json_parse
      
      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(3)
      
      items[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        
        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:unit_price]).to be >= 10.00
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
    
    it 'returns items data matching max and min price' do
      get find_all_api_v1_items_path, params: { max_price: 11.00, min_price: 6.00 }
      items = json_parse
      
      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(2)
      
      items[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
        
        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')
        
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:unit_price]).to be_within(6.00).of(11.00)
        
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
    
    it 'returns data even if one match found' do
      get find_all_api_v1_items_path, params: { name: 'Abc' }
      items = json_parse
    
      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(1)
    
      items[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
    
        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')
    
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:name]).to match('Abc')
        
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
    
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
    
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'returns data even if no matches found' do
      get find_all_api_v1_items_path, params: { name: 'zzz' }
      items = json_parse
    
      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(0)
      expect(items[:data]).to be_empty
    end
  end
end
