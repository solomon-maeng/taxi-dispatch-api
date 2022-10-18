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
        let(:header) { valid_header(passenger_user.id) }

        it '자신이 요청한 배차 요청만 조회가 가능하다.' do
          after_date_time, before_date_time = parse_date_time

          expect(after_date_time.after?(before_date_time)).to eq true
          expect(response).to have_http_status(:ok)
          expect(subject.size).to eq 10
          subject.each do |data|
            expect(data['passengerId']).to eq passenger_user.id
          end
        end
      end

      context 'user_type이 driver라면,' do
        let(:header) { valid_header(driver_user.id) }

        it '모든 배차 요청 조회가 가능하다.' do
          after_date_time, before_date_time = parse_date_time

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

    def parse_date_time
      after_date_time = DateTime.parse subject[0]['createdAt']
      before_date_time = DateTime.parse subject[1]['createdAt']
      [after_date_time, before_date_time]
    end
  end

  describe '#create' do
    subject { JSON.parse(response.body) }

    context '승객이 배차 요청을 보내는 경우,' do
      let(:passenger_user) { create(:user, user_type: 'passenger') }
      let(:driver_user) { create(:user, user_type: 'driver') }
      let!(:pending_request) { create(:taxi_request, passenger_id: passenger_user.id) }

      before { post '/taxi-requests', params:, headers: header }

      context '배차 요청이 성공하고,' do
        let(:header) { valid_header(passenger_user.id) }
        let(:pending_request) {}
        let(:params) { { address: Faker::Address.full_address } }

        it '생성된 배차 요청 정보를 반환한다.' do
          expect(response).to have_http_status(:created)
          expect(subject['id']).not_to be_nil
          expect(subject['passengerId']).to eq passenger_user.id
          expect(subject['acceptedAt']).to be_nil
          expect(subject['status']).to eq TaxiRequest.statuses[:pending]
          expect(subject['driverId']).not_to be_nil
        end
      end

      context '인증되지 않은 사용자가 접근하면,' do
        let(:header) {}
        let(:params) {}

        it_behaves_like 'UnAuthorized 응답 처리', :request
      end

      context '입력 주소가 없으면,' do
        let(:header) { valid_header(passenger_user.id) }
        let(:pending_request) {}
        let(:params) {}

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '필수 파라메터가 필요합니다: address' }
        end
      end

      context '입력 주소가 있으나 허용된 문자열 길이를 초과한 경우,' do
        let(:header) { valid_header(passenger_user.id) }
        let(:pending_request) {}
        let(:params) do
          {
            address: 'a' * 101
          }
        end

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '주소는 100자 이하로 입력해주세요' }
        end
      end

      context '요청 송신 사용자가 승객이 아니라면,' do
        let(:header) { valid_header(driver_user.id) }
        let(:params) { { address: Faker::Address.full_address } }

        it_behaves_like 'Forbidden 응답 처리', :request do
          let(:message) { '승객만 배차 요청할 수 있습니다' }
        end
      end

      context '아직 대기 중인 배차 요청이 있다면,' do
        let(:header) { valid_header(passenger_user.id) }
        let(:params) { { address: Faker::Address.full_address } }

        it_behaves_like 'Conflict 응답 처리', :request do
          let(:message) { '아직 대기중인 배차 요청이 있습니다' }
        end
      end
    end
  end
end
