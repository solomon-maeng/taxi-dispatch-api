# frozen_string_literal: true

class TaxiRequestsController < ApplicationController

  def index
    taxi_requests = if current_user.user_type.eql? User.user_types[:passenger]
                      TaxiRequest.order(created_at: :desc).where(passenger_id: current_user.id)
                    else
                      TaxiRequest.order(created_at: :desc)
                    end

    json_success taxi_requests.map { |request| TaxiRequestSerializer.new(request).serialized_json }
  end

  def create
    params = create_param
    pending_request = TaxiRequest.find_by(status: TaxiRequest.statuses[:pending])
    raise Exceptions::Forbidden, '승객만 배차 요청할 수 있습니다' unless current_user.passenger?
    raise Exceptions::Conflict, '아직 대기중인 배차 요청이 있습니다' unless pending_request.nil?

    request = TaxiRequest.create!(
      passenger_id: params[:passenger_id],
      driver_id: 0,
      address: params[:address],
      status: TaxiRequest.statuses[:pending]
    )

    json_create_success TaxiRequestSerializer.new(request).serialized_json
  end

  private

  def create_param
    params.require(:address)
    params.merge(passenger_id: current_user.id).permit(:passenger_id, :address)
  end
end
