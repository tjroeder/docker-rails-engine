class Api::V1::Items::MerchantController < ApplicationController
  before_action :set_item, only: %i[index]

  def index
    @merchant = @item.merchant

    json_string = MerchantSerializer.new(@merchant)
    json_response(json_string)
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
