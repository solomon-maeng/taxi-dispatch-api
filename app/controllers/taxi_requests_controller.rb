# frozen_string_literal: true

class TaxiRequestsController < ApplicationController

  def index
    taxi_requests = if current_user.user_type.eql? 'passenger'
                      TaxiRequest.order(created_at: :desc).where(passenger_id: current_user.id)
                    else
                      TaxiRequest.order(created_at: :desc)
                    end

    json_success taxi_requests.map { |request| TaxiRequestSerializer.new(request).serialized_json }
  end
end
