# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenParser, type: :service do

  describe '토큰 파싱 개체' do
    context '인자로 전달된 token이 잘못된 경우,' do
      let(:invalid_token) { 'invalid_token' }

      it '예외가 발생한다.' do
        sut = described_class.new

        expect { sut.parse(invalid_token) }
          .to raise_error(Exceptions::Unauthorized)
      end
    end

    context '인자로 전달된 token이 유효한 경우,' do
      let(:user_id) { Faker::Number.number }

      it 'user_id가 반환된다.' do
        # Arrange
        token = TokenGenerator.new.generate(user_id:)
        sut = described_class.new

        # Act
        result = sut.parse(token)

        # Assert
        expect(result['user_id']).to eq user_id
      end
    end
  end
end
