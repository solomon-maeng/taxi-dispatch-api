# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password_digest { Faker::Internet.password }
    user_type { User.user_types.keys.sample }
  end
end
