# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaxiRequestsController', type: :request do

  describe '#index' do
    subject { JSON.parse(response.body) }

    context '모든 택시 배차 요청 목록을 조회 시' do
      let(:driver_user) { create(:user, user_type: 'driver') }
      let(:passenger_user) { create(:user, user_type: 'passenger') }
      let!(:taxi_requests) { create_list(:taxi_request, 10, passenger_id: passenger_user.id) }
      let!(:random_taxi_requests) { create_list(:taxi_request, 10, driver_id: driver_user.id, status: TaxiRequest.statuses.keys.sample) }

      context 'user_type이 passenger라면,' do
        let(:token) { TokenGenerator.new.generate(user_id: passenger_user.id) }
        let(:header) { { 'Authorization' => "Token #{token}" } }

        before { get '/taxi-requests', params: {}, headers: header }

        it '자신이 요청한 배차 요청만 조회가 가능하다.' do
          expect(response).to have_http_status(:ok)
          expect(subject.size).to eq 10
          expect(subject[0]['passengerId']).to eq passenger_user.id
        end
      end

      context 'user_type이 driver라면,' do
        let(:token) { TokenGenerator.new.generate(user_id: driver_user.id) }
        let(:header) { { 'Authorization' => "Token #{token}" } }

        before { get '/taxi-requests', params: {}, headers: header }

        it '모든 배차 요청 조회가 가능하다.' do
          expect(response).to have_http_status(:ok)
          expect(subject.size).to eq 20
        end
      end
    end
  end
end
