class Api::V1::Items::SearchController < ApplicationController
  before_action :search_params, only: :find_all
  before_action :too_many_params, only: :find_all
  before_action :invalid_max_min_params, only: :find_all

  def find_all
    if @name.present?
      @items = Item.find_all_by_name(@name)
      json_string = ItemSerializer.new(@items)
      json_response(json_string)
    elsif @max.present? || @min.present?
      @items = Item.max_min_price(max: @max, min: @min)
      json_string = ItemSerializer.new(@items)
      json_response(json_string)
    else
      json_response(@name, :bad_request)
    end
  end

  private

  def search_params
    permitted = params.permit(:name, :max_price, :min_price)
    @name = permitted[:name]
    @max = permitted[:max_price]
    @min = permitted[:min_price]
  end

  def too_many_params
    render status: :bad_request if @name && (@max || @min)
  end

  def invalid_max_min_params
    render status: :bad_request if @max.to_f.negative? || @min.to_f.negative?
  end
end
