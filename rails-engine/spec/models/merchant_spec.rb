require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many :items }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'factory' do
    it 'can create a factory with name' do
      merchant = create(:merchant, name: 'Wacky Wally World')

      expect(merchant).to be_valid
      expect(merchant).to be_a(Merchant)
      expect(merchant).to have_attributes(name: 'Wacky Wally World')
    end
  end

  describe 'class methods' do
    describe '::find_one_by_name' do
      it 'should return a merchant from case insensitive search' do
        create(:merchant, name: 'Turing')
        create(:merchant, name: 'Ring World')
        create(:merchant, name: 'Abc')
        expected = create(:merchant, name: 'Boringo')
  
        expect(Merchant.find_one_by_name('Ring')).to eq(expected)
        expect(Merchant.find_one_by_name('ring')).to eq(expected)
        expect(Merchant.find_one_by_name('RING')).to eq(expected)
        expect(Merchant.find_one_by_name('rInG')).to eq(expected)
      end

      it 'should return a merchant case sensitive alphabetically if multiple matches' do
        create(:merchant, name: 'Turing')
        create(:merchant, name: 'aRing World')
        create(:merchant, name: 'Abc')
        expected = create(:merchant, name: 'Boringo')
  
        expect(Merchant.find_one_by_name('ring')).to eq(expected)
      end
    end
  end
end
