# frozen_string_literal: true

require 'rails_helper'
require 'shared_helper'

RSpec.describe 'ApplicationController', type: :request do

  subject { JSON.parse(response.body) }

  describe '#authenticate_request' do
    let(:header) {}
    before { get '/users/me', params: {}, headers: header }

    context 'HTTP Header에 토큰이 없는 경우,' do

      it_behaves_like 'UnAuthorized 응답 처리', :request
    end

    context 'HTTP Header에 전달한 토큰의 형식이 잘못된 경우,' do
      let(:header) { { 'Authorization' => 'Token aaa' } }

      it_behaves_like 'UnAuthorized 응답 처리', :request
    end

    context 'HTTP Header에 전달한 토큰이 만료된 경우,' do
      let(:header) { { 'Authorization' => 'Token eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0NjQxMTAzNDU5LCJleHAiOjE2MDk0MzQwMDB9.IDq_o0AvfV9vMZJfnLhNetdiXtxWTwAYpesG-v5fCLw' } }

      it_behaves_like 'UnAuthorized 응답 처리', :request
    end

    context 'HTTP Header에 전달한 토큰이 정상적이지만,' do
      let(:user_id) { Faker::Number.number }
      let(:token) { TokenGenerator.new.generate(user_id:) }

      context '토큰 파싱 후 사용자를 조회 시, 찾을 수 없는 경우,' do
        let(:header) { { 'Authorization' => "Token #{token}" } }

        it_behaves_like 'Not found 응답 처리', :request do
          let(:message) { '존재하지 않는 회원입니다' }
        end
      end
    end

    context 'HTTP Header에 전달한 토큰이 정상적이고,' do
      let(:user) { create(:user) }
      let(:token) { TokenGenerator.new.generate(user_id: user.id) }

      context '사용자의 정보 조회가 성공하면' do
        let(:header) { { 'Authorization' => "Token #{token}" } }

        it '200 응답과 함께 사용자 정보가 반환된다.' do
          expect(response).to have_http_status(:ok)
          expect(subject['id']).to_not be_nil
        end
      end
    end
  end
end
