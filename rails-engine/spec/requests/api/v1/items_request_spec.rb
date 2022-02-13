require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  describe '#index action' do
    it 'returns a successful status' do
      create_list(:item, 3)
      get api_v1_items_path

      expect(response).to have_http_status(200)
    end

    it 'returns a list of all items' do
      create_list(:item, 3)
      get api_v1_items_path
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

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'returns an array of data even if no items' do
      get api_v1_items_path
      items = json_parse

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].empty?).to eq(true)
    end

    it 'returns an array of data if one item' do
      create(:item)
      get api_v1_items_path
      items = json_parse

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data].count).to eq(1)
      expect(items[:data].empty?).to eq(false)
    end

    it 'does not include dependent data' do
      create_list(:item, 3)
      get api_v1_items_path
      items = json_parse

      items[:data].each do |item|
        expect(item).to_not have_key(:relationships)
      end
    end
  end

  describe '#show action' do
    it 'returns a successful status if found' do
      item = create(:item)
      get api_v1_item_path(item)

      expect(response).to have_http_status(200)
    end

    it 'returns an item' do
      create_list(:item, 3)
      item = create(:item)
      get api_v1_item_path(item)
      item_parsed = json_parse

      expect(item_parsed).to be_a(Hash)
      expect(item_parsed[:data]).to be_a(Hash)

      expect(item_parsed[:data]).to have_key(:id)
      expect(item_parsed[:data][:id]).to be_an(String)

      expect(item_parsed[:data]).to have_key(:type)
      expect(item_parsed[:data][:type]).to eq('item')

      expect(item_parsed[:data][:attributes]).to have_key(:name)
      expect(item_parsed[:data][:attributes][:name]).to be_a(String)
      
      expect(item_parsed[:data][:attributes]).to have_key(:description)
      expect(item_parsed[:data][:attributes][:description]).to be_a(String)

      expect(item_parsed[:data][:attributes]).to have_key(:unit_price)
      expect(item_parsed[:data][:attributes][:unit_price]).to be_a(Float)

      expect(item_parsed[:data][:attributes]).to have_key(:merchant_id)
      expect(item_parsed[:data][:attributes][:merchant_id]).to be_a(Integer)
    end

    it 'does not include dependent data' do
      item = create(:item)
      get api_v1_item_path(item)
      item_parsed = json_parse

      expect(item_parsed[:data]).to_not have_key(:relationships)
    end
  end

  describe '#create action' do
    let!(:merch) { create(:merchant) }
    let!(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let!(:item_params) { { name: 'Snowboard', description: 'It is very fast', unit_price: 3.50, merchant_id: merch.id } }
    
    it 'returns a successful status if created' do
      post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)
      
      expect(response).to have_http_status(201)
    end
    
    it 'returns an newly created item' do
      post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)
      item_parsed = json_parse

      expect(item_parsed).to be_a(Hash)
      expect(item_parsed[:data]).to be_a(Hash)

      expect(item_parsed[:data]).to have_key(:id)
      expect(item_parsed[:data][:id]).to be_an(String)

      expect(item_parsed[:data]).to have_key(:type)
      expect(item_parsed[:data][:type]).to eq('item')

      expect(item_parsed[:data][:attributes]).to have_key(:name)
      expect(item_parsed[:data][:attributes][:name]).to eq('Snowboard')
      
      expect(item_parsed[:data][:attributes]).to have_key(:description)
      expect(item_parsed[:data][:attributes][:description]).to eq('It is very fast')

      expect(item_parsed[:data][:attributes]).to have_key(:unit_price)
      expect(item_parsed[:data][:attributes][:unit_price]).to eq(3.50)

      expect(item_parsed[:data][:attributes]).to have_key(:merchant_id)
      expect(item_parsed[:data][:attributes][:merchant_id]).to eq(merch.id)
    end

    it 'returns an error if all attributes are missing' do
      post api_v1_items_path, headers: headers, params: JSON.generate(item: {})

      expect(response).to have_http_status(422)
    end

    it 'returns an error if missing an attribute' do
      missing_params = { description: 'It is very fast', unit_price: 3.50, merchant_id: merch.id }
      post api_v1_items_path, headers: headers, params: JSON.generate(item: missing_params)

      expect(response).to have_http_status(422)
    end

    it 'returns an error status if given attribute with incorrect type' do
      wrong_params = { name: 'Snowboard', description: 'It is very fast', unit_price: 'price', merchant_id: merch.id }
      post api_v1_items_path, headers: headers, params: JSON.generate(item: wrong_params)

      expect(response).to have_http_status(422)
    end
    
    it 'returns an error status if given a non valid merchant id' do
      wrong_params = { name: 'Snowboard', description: 'It is very fast', unit_price: 3.50, merchant_id: merch.id + 1 }
      post api_v1_items_path, headers: headers, params: JSON.generate(item: wrong_params)
  
      expect(response).to have_http_status(422)
    end
    
    it 'returns a valid item even when given unused attribute' do
      wrong_params =  { name: 'Snowboard', description: 'It is very fast', unit_price: 3.50, merchant_id: merch.id, unused: true }
      post api_v1_items_path, headers: headers, params: JSON.generate(item: wrong_params)
  
      expect(response).to have_http_status(201)
    end
  end

  describe '#update action' do
    let!(:item) { create(:item) }
    let!(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

    it 'returns a successful status when given json update' do
      item_params = { name: 'New name' }
      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(200)
    end

    it 'returns an item with an updated attribute' do
      old_attributes = item.attributes
      item_params = { name: 'New name' }
      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)

      item_parsed = json_parse

      expect(item_parsed).to be_a(Hash)
      expect(item_parsed[:data]).to be_a(Hash)

      expect(item_parsed[:data]).to have_key(:id)
      expect(item_parsed[:data][:id]).to be_an(String)

      expect(item_parsed[:data]).to have_key(:type)
      expect(item_parsed[:data][:type]).to eq('item')

      expect(item_parsed[:data][:attributes]).to have_key(:name)
      expect(item_parsed[:data][:attributes][:name]).not_to eq(old_attributes['name'])
      expect(item_parsed[:data][:attributes][:name]).to eq('New name')

      expect(item_parsed[:data][:attributes]).to have_key(:description)
      expect(item_parsed[:data][:attributes][:description]).to eq(old_attributes['description'])

      expect(item_parsed[:data][:attributes]).to have_key(:unit_price)
      expect(item_parsed[:data][:attributes][:unit_price]).to eq(old_attributes['unit_price'])

      expect(item_parsed[:data][:attributes]).to have_key(:merchant_id)
      expect(item_parsed[:data][:attributes][:merchant_id]).to eq(old_attributes['merchant_id'])
    end

    it 'returns an error status if given attribute with incorrect type' do
      item_params = { unit_price: 'price' }
      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)
 
      expect(response).to have_http_status(404)
    end

    it 'returns an error status if given a non valid merchant id' do
      item_params = { name: 'Snowboard', merchant_id: Merchant.last.id + 1 }
      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)
      
      expect(response).to have_http_status(404)
    end
    
    it 'returns a valid item even when given unused attribute' do
      old_attributes = item.attributes
      item_params = {  name: 'New name', unused: true }
      patch api_v1_item_path(item), headers: headers, params: JSON.generate(item: item_params)
      
      expect(response).to have_http_status(200)

      item_parsed = json_parse
      
      expect(item_parsed).to be_a(Hash)
      expect(item_parsed[:data]).to be_a(Hash)
      
      expect(item_parsed[:data]).to have_key(:id)
      expect(item_parsed[:data][:id]).to be_an(String)
      
      expect(item_parsed[:data]).to have_key(:type)
      expect(item_parsed[:data][:type]).to eq('item')
      
      expect(item_parsed[:data][:attributes]).to have_key(:name)
      expect(item_parsed[:data][:attributes][:name]).not_to eq(old_attributes['name'])
      expect(item_parsed[:data][:attributes][:name]).to eq('New name')
      
      expect(item_parsed[:data][:attributes]).to have_key(:description)
      expect(item_parsed[:data][:attributes][:description]).to eq(old_attributes['description'])
      
      expect(item_parsed[:data][:attributes]).to have_key(:unit_price)
      expect(item_parsed[:data][:attributes][:unit_price]).to eq(old_attributes['unit_price'])
      
      expect(item_parsed[:data][:attributes]).to have_key(:merchant_id)
      expect(item_parsed[:data][:attributes][:merchant_id]).to eq(old_attributes['merchant_id'])
    end
  end

  describe '#destroy action' do
    let!(:item1) { create(:item) }
    let!(:item2) { create(:item) }
    let!(:invoice_items) { create_list(:invoice_item, 3, item: item1) }
    let!(:invoice) { invoice_items[1].invoice }
    let!(:invoice_item) { create(:invoice_item, item: item2, invoice: invoice) }

    it 'returns a successful status when deleted' do
      delete api_v1_item_path(item1)
      
      expect(response).to have_http_status(204)
    end

    it 'returns no json body' do
      delete api_v1_item_path(item1)
      
      expect(response.body).to be_empty
    end
    
    it 'returns no item at previous id when deleted' do
      delete api_v1_item_path(item1)
      get api_v1_item_path(item1)

      expect(response).to have_http_status(404)
    end

    it 'deletes any invoice items associated with the item' do
      expect(InvoiceItem.count).to eq(4)

      delete api_v1_item_path(item1)
      expect(InvoiceItem.count).to eq(1)
    end

    it 'deletes any invoices which only have the deleted item' do
      expect(Invoice.count).to eq(3)

      delete api_v1_item_path(item1)
      expect(Invoice.count).to eq(1)
    end
  end
end
