require 'rails_helper'

RSpec.describe TokenGenerator, type: :service do

  describe '토큰 생성 개체' do
    let(:user_id) { Faker::Number.number }

    it 'user_id 값을 사용하여 토큰을 생성한다.' do
      # Arrange
      sut = described_class.new

      # Act
      token = sut.generate(user_id:)

      # Assert
      expect(token).not_to be_nil
      expect(token.split('.').size).to eq 3
    end
  end
end
