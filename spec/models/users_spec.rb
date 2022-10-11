# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  describe '유저 모델이 공백 여부를 검증한다.' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:user_type) }
    it { should validate_presence_of(:password_digest) }
  end

  describe '유저 모델의 이메일이 유일한 지 검증한다.' do
    let!(:user) { create(:user) }

    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe '유저 모델의 user_type이 존재하는지 검증한다.' do
    it { should validate_inclusion_of(:user_type).in?(%w(passenger driver)) }
  end
end
