class Api::V1::Merchants::ItemsController < ApplicationController
  before_action :set_merchant, only: %i[index]

  def index
    @items = @merchant.items
    json_string = ItemSerializer.new(@items)
    json_response(json_string)
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
