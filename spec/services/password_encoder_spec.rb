# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordEncoder, type: :service do

  describe '패스워드 암호화 개체' do
    let(:raw_password) { '12345678' }
    let(:invalid_password) { '1234' }

    context '입력 패스워드와 암호화된 패스워드가 일치하지 않으면,' do

      it '에러가 발생한다.' do
        sut = described_class.new
        encoded_password = sut.encode(raw_password)

        expect { sut.decode(invalid_password, encoded_password) }
          .to raise_error(Exceptions::BadRequest)
      end
    end
  end
end
