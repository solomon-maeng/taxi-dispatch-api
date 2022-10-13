# frozen_string_literal: true

require 'rails_helper'
require 'shared_helper'

RSpec.describe 'UsersController', type: :request do
  describe '#sign_in' do
    let(:user) { create(:user) }
    let(:params) { { email: Faker::Internet.unique.email, password: Faker::Internet.password } }
    def request
      post '/users/sign-in', params:, headers: {}
    end

    subject { JSON.parse(response.body) }

    context '요청 파라미터인' do
      context '이메일이 비어있다면,' do
        before { params[:email] = '' }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '필수 파라메터가 필요합니다: email' }
        end
      end
      context '비밀번호가 비어있다면,' do
        before { params[:password] = '' }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '필수 파라메터가 필요합니다: password' }
        end
      end
    end

    context '가입 이메일이 유효하지 않은 경우,' do
      before { params[:email] = Faker::Internet.unique.email }

      it_behaves_like 'Bad Request 응답 처리', :request do
        let(:message) { '아이디와 비밀번호를 확인해주세요' }
      end
    end

    context '비밀번호가 유효하지 않은 경우,' do
      before { params[:email] = user.email }

      it_behaves_like 'Bad Request 응답 처리', :request do
        let(:message) { '아이디와 비밀번호를 확인해주세요' }
      end
    end
  end

  describe '#sign_up' do
    let(:user) { create(:user) }
    let(:params) { { email: Faker::Internet.unique.email, password: Faker::Internet.password, userType: User.user_types.keys.sample } }
    def request
      post '/users/sign-up', params:, headers: {}
    end

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

    context '요청 파라미터인' do
      context '이메일이 비어있다면,' do
        before { params[:email] = '' }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '필수 파라메터가 필요합니다: email' }
        end
      end

      context '비밀번호가 비어있다면,' do
        before { params[:password] = '' }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '필수 파라메터가 필요합니다: password' }
        end
      end

      context 'user_type이 비어있다면,' do
        before { params[:userType] = '' }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '필수 파라메터가 필요합니다: userType' }
        end
      end
    end

    context '요청 파라미터 중 이메일 형식이 잘못된 경우,' do
      before { params[:email] = 'aaa@aaa' }

      it_behaves_like 'Bad Request 응답 처리', :request do
        let(:message) { '올바른 이메일을 입력해주세요' }
      end
    end

    context '요청 파라미터 중 user_type이 올바르지 않은 경우,' do
      before { params[:userType] = 'foo' }

      it_behaves_like 'Bad Request 응답 처리', :request do
        let(:message) { '올바른 userType을 입력해주세요' }
      end
    end

    context '요청 파라미터로 기입된 이메일이 이미 가입된 경우,' do
      before { params[:email] = user.email }

      it_behaves_like 'Conflict 응답 처리', :request do
        let(:message) { '이미 가입된 이메일입니다' }
      end
    end
  end
end
