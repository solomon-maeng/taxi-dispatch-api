# frozen_string_literal: true

class TokenExtractor

  HEADER_PREFIX = 'Token '

  def extract(payload)
    raise Exceptions::Unauthorized, '로그인이 필요합니다' if payload.nil? || payload.length < HEADER_PREFIX.length

    payload[HEADER_PREFIX.length, payload.length]
  end

end
