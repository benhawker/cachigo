class HotelsController < ApplicationController

  def index
    response = ResponseBuilder.new(params: stay_params, cache_store: Cache).build

    if response[:data]
      render json: response, status: :ok
    else
      render json: response, status: :unprocessable_entity
    end
  end

  private

  def stay_params
    {
      checkin: params[:checkin],
      checkout: params[:checkout] ,
      destination: params[:destination],
      guests: params[:guests],
      suppliers: params[:suppliers]
    }
  end
end