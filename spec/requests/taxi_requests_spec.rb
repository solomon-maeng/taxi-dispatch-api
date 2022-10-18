# frozen_string_literal: true

require 'rails_helper'
require 'shared_helper'

RSpec.describe 'TaxiRequestsController', type: :request do

  describe '#index' do
    subject { JSON.parse(response.body) }

    context '모든 택시 배차 요청 목록을 조회 시' do
      let(:driver_user) { create(:user, user_type: 'driver') }
      let(:passenger_user) { create(:user, user_type: 'passenger') }
      let!(:taxi_requests) { create_list(:taxi_request, 10, passenger_id: passenger_user.id) }
      let!(:random_taxi_requests) { create_list(:taxi_request, 10, driver_id: driver_user.id, status: TaxiRequest.statuses.keys.sample) }

      before { get '/taxi-requests', params: {}, headers: header }

      context 'user_type이 passenger라면,' do
        let(:token) { TokenGenerator.new.generate(user_id: passenger_user.id) }
        let(:header) { { 'Authorization' => "Token #{token}" } }

        it '자신이 요청한 배차 요청만 조회가 가능하다.' do
          after_date_time = DateTime.parse subject[0]['createdAt']
          before_date_time = DateTime.parse subject[1]['createdAt']

          expect(after_date_time.after?(before_date_time)).to eq true
          expect(response).to have_http_status(:ok)
          expect(subject.size).to eq 10
          subject.each do |data|
            expect(data['passengerId']).to eq passenger_user.id
          end
        end
      end

      context 'user_type이 driver라면,' do
        let(:token) { TokenGenerator.new.generate(user_id: driver_user.id) }
        let(:header) { { 'Authorization' => "Token #{token}" } }

        it '모든 배차 요청 조회가 가능하다.' do
          after_date_time = DateTime.parse subject[0]['createdAt']
          before_date_time = DateTime.parse subject[1]['createdAt']

          expect(after_date_time.after?(before_date_time)).to eq true
          expect(response).to have_http_status(:ok)
          expect(subject.size).to eq 20
        end
      end

      context '인증되지 않은 사용자가 접근하면,' do
        let(:header) {}

        it_behaves_like 'UnAuthorized 응답 처리', :request
      end
    end
  end

  describe '#create' do
    subject { JSON.parse(response.body) }

    context '승객이 배차 요청을 보내는 경우,' do
      let(:passenger_user) { create(:user, user_type: 'passenger') }

      before { post '/taxi-requests', params:, headers: header }

      context '인증되지 않은 사용자가 접근하면,' do
        let(:header) {}
        let(:params) {}

        it_behaves_like 'UnAuthorized 응답 처리', :request
      end

      context '입력 주소가 없으면,' do
        let(:token) { TokenGenerator.new.generate(user_id: passenger_user.id) }
        let(:header) { { 'Authorization' => "Token #{token}" } }
        let(:params) {}

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '필수 파라메터가 필요합니다: address' }
        end
      end

      context '입력 주소가 있으나 허용된 문자열 길이를 초과한 경우,' do
        let(:token) { TokenGenerator.new.generate(user_id: passenger_user.id) }
        let(:header) { { 'Authorization' => "Token #{token}" } }
        let(:params) do
          {
            address: 'a' * 101
          }
        end

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '주소는 100자 이하로 입력해주세요' }
        end
      end
    end
  end
end
