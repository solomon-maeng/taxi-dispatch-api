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

  def accept
    request = TaxiRequest.find(accept_params[:id])
    raise Exceptions::Conflict, '수락할 수 없는 배차 요청입니다. 다른 배차 요청을 선택하세요' if request.accepted?
    raise Exceptions::Forbidden, '기사만 배차 요청을 수락할 수 있습니다' unless current_user.driver?

    request.accepted_by(current_user)

    json_success TaxiRequestSerializer.new(request).serialized_json
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::NotFound, '존재하지 않는 배차 요청입니다'
  end

  def create
    pending_request = TaxiRequest.find_by(status: TaxiRequest.statuses[:pending])
    raise Exceptions::Forbidden, '승객만 배차 요청할 수 있습니다' unless current_user.passenger?
    raise Exceptions::Conflict, '아직 대기중인 배차 요청이 있습니다' if pending_request.present?

    request = TaxiRequest.create!(
      passenger_id: create_params[:passenger_id],
      driver_id: 0,
      address: create_params[:address],
      status: TaxiRequest.statuses[:pending]
    )

    json_create_success TaxiRequestSerializer.new(request).serialized_json
  end

  private

  def create_params
    params.require(:address)
    params.merge(passenger_id: current_user.id).permit(:passenger_id, :address)
  end

  def accept_params
    params.require(:id)
    params.permit(:id)
  end
end
