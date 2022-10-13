# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenExtractor, type: :service do
  describe '토큰 추출 개체' do
    context 'payload가 정상적인 경우' do
      let(:payload) { 'Token jwt.example.token' }

      it '추출된 토큰이 반환된다.' do
        sut = described_class.new

        token = sut.extract(payload)

        expect(token).not_to be_nil
      end
    end

    context 'payload가 nil인 경우' do
      it '예외가 발생한다.' do
        sut = described_class.new

        expect { sut.extract(nil) }
          .to raise_error(Exceptions::Unauthorized)
      end
    end

    context 'payload가 header의 prefix보다 작은 경우' do
      it '예외가 발생한다.' do
        sut = described_class.new

        expect { sut.extract('aaa') }
          .to raise_error(Exceptions::Unauthorized)
      end
    end
  end
end
