# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  describe '유저 모델의 공백 여부를 검증한다.' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:user_type) }
    it { is_expected.to validate_presence_of(:password_digest) }
  end

  describe '유저 모델의 이메일이 유일하면 검증에 성공한다.' do
    let!(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe '유저 모델의 이메일 형식을 검증한다.' do

    it { is_expected.not_to allow_value('foobar').for(:email) }
    it { is_expected.not_to allow_value('aaa@aaa').for(:email) }
  end

  describe '유저 모델의 user_type 일치 여부를 검증한다.' do
    it do
      is_expected.to define_enum_for(:user_type).with_values(passenger: 'passenger', driver: 'driver')
                                                .backed_by_column_of_type(:string)
    end
  end
end
