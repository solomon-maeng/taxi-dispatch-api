# frozen_string_literal: true

class TokenParser

  def parse(token)
    JWT.decode(token, secret_key)[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature
    raise Exceptions::Unauthorized, '로그인이 필요합니다'
  end

  private

  def secret_key
    Rails.application.secret_key_base
  end
end
