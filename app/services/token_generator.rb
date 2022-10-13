# frozen_string_literal: true

class TokenGenerator

  def generate(payload, exp = 2.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret_key)
  end

  private

  def secret_key
    Rails.application.secret_key_base
  end
end
