class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: %i[show]

  def index
    @merchants = Merchant.all

    json_string = MerchantSerializer.new(@merchants)
    json_response(json_string)
  end

  def show
    json_string = MerchantSerializer.new(@merchant)
    json_response(json_string)
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
