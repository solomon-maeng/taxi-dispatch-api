# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApplicationController', type: :request do

  subject { JSON.parse(response.body) }

  describe '#authenticate_request' do

    context 'HTTP Header에 토큰이 없는 경우,' do
      before { get '/taxi-requests', params: {}, headers: {} }

      it '401 UnAuthorized 예외가 발생한다.' do
        expect(response).to have_http_status(:unauthorized)
        expect(subject['message']).to eq '로그인이 필요합니다'
      end
    end

    context 'HTTP Header에 전달한 토큰의 형식이 잘못된 경우,' do
      let(:header) { { 'Authorization' => 'Token aaa' } }
      before { get '/taxi-requests', params: {}, headers: header }

      it '401 UnAuthorized 예외가 발생한다.' do
        expect(response).to have_http_status(:unauthorized)
        expect(subject['message']).to eq '로그인이 필요합니다'
      end
    end

    context 'HTTP Header에 전달한 토큰이 만료된 경우,' do
      let(:header) { { 'Authorization' => 'Token eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0NjQxMTAzNDU5LCJleHAiOjE2MDk0MzQwMDB9.IDq_o0AvfV9vMZJfnLhNetdiXtxWTwAYpesG-v5fCLw' } }
      before { get '/taxi-requests', params: {}, headers: header }

      it '401 UnAuthorized 예외가 발생한다.' do
        expect(response).to have_http_status(:unauthorized)
        expect(subject['message']).to eq '로그인이 필요합니다'
      end
    end
  end
end
