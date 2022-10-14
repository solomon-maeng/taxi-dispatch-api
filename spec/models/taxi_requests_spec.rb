# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaxiRequest, type: :model do

  describe '택시 요청 모델의 공백 여부를 검증한다.' do
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:driver_id) }
    it { is_expected.to validate_presence_of(:passenger_id) }
  end

  describe '택시 요청 모델의 주소 최대 길이가 100이 맞는지 검증한다.' do
    it { is_expected.to validate_length_of(:address).is_at_most(100) }
  end

  describe '택시 요청 모델의 status 일치 여부를 검증한다.' do
    it do
      is_expected.to define_enum_for(:status).with_values(pending: 'pending', accepted: 'accepted')
                                                .backed_by_column_of_type(:string)
    end
  end
end
