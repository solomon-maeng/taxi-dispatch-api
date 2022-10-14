# frozen_string_literal: true

shared_examples 'Bad Request 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before { send request_method_name }

    it do
      expect(response).to have_http_status(:bad_request)
      expect(subject['message']).to eq(message)
    end
  end
end

shared_examples 'Not found 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before { send request_method_name }

    it do
      expect(response).to have_http_status(:not_found)
      expect(subject['message']).to eq(message)
    end
  end
end

shared_examples 'Conflict 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before { send request_method_name }

    it do
      expect(response).to have_http_status(:conflict)
      expect(subject['message']).to eq(message)
    end
  end
end

shared_examples 'UnAuthorized 응답 처리' do |request_method_name|
  describe '응답' do
    subject { JSON.parse(response.body) }

    before { send request_method_name }

    it do
      expect(response).to have_http_status(:unauthorized)
      expect(subject['message']).to eq('로그인이 필요합니다')
    end
  end
end
