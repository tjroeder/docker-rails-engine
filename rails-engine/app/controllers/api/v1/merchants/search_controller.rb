class Api::V1::Merchants::SearchController < ApplicationController
  def find
    @merchant = Merchant.find_one_by_name(params[:name])
    if @merchant.nil?
      json_string = JSON.generate(data: {})
      json_response(json_string)
    elsif params[:name].present? && @merchant
      json_string = MerchantSerializer.new(@merchant)
      json_response(json_string)
    else
      json_response(params[:name], :bad_request)
    end
  end
end
