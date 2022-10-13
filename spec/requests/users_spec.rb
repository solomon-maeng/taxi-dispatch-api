# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe '#sign_up' do
    let(:user) { create(:user) }

    subject { JSON.parse(response.body) }

    context '요청 파라미터가 유효한 경우,' do
      let(:valid_params) do
        {
          email: 'msolo021015@gmail.com',
          password: Faker::Internet.password,
          userType: 'passenger'
        }
      end
      before { post '/users/sign-up', params: valid_params, headers: {} }

      it '새로운 사용자를 생성한다.' do
        expect(response).to have_http_status(:created)
        expect(subject['email']).to eq 'msolo021015@gmail.com'
        expect(subject['id']).to_not be_nil
        expect(subject['userType']).to eq 'passenger'
        expect(subject['createdAt']).to_not be_nil
        expect(subject['updatedAt']).to_not be_nil
      end
    end

    context '요청 파라미터 중 이메일 형식이 잘못된 경우,' do
      let(:invalid_email) do
        {
          email: 'aaa@aaa',
          password: Faker::Internet.password,
          userType: User.user_types.keys.sample
        }
      end
      before { post '/users/sign-up', params: invalid_email, headers: {} }

      it '400 BadRequest 응답과 에러 메세지를 반환한다.' do
        expect(response).to have_http_status(:bad_request)
        expect(subject['message']).to eq '올바른 이메일을 입력해주세요'
      end
    end

    context '요청 파라미터 중 user_type이 올바르지 않은 경우,' do
      let(:invalid_user_type) do
        {
          email: Faker::Internet.unique.email,
          password: Faker::Internet.password,
          userType: 'foo'
        }
      end
      before { post '/users/sign-up', params: invalid_user_type, headers: {} }

      it '400 BadRequest 응답과 에러 메세지를 반환한다.' do
        expect(response).to have_http_status(:bad_request)
        expect(subject['message']).to eq '올바른 userType을 입력해주세요'
      end
    end

    context '요청 파라미터로 기입된 이메일이 이미 가입된 경우,' do
      let(:duplicate_email) do
        {
          email: user.email,
          password: Faker::Internet.password,
          userType: User.user_types.keys.sample
        }
      end
      before { post '/users/sign-up', params: duplicate_email, headers: {} }

      it '409 Conflict 응답과 에러 메세지를 반환한다.' do
        expect(response).to have_http_status(:conflict)
        expect(subject['message']).to eq '이미 가입된 이메일입니다'
      end
    end
  end
end
