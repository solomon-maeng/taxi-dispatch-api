# frozen_string_literal: true

FactoryBot.define do
  factory :taxi_request do
    driver_id { 0 }
    passenger_id { 0 }
    address { Faker::Address.full_address }
    status { 'pending' }
  end
end
