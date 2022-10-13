# frozen_string_literal: true

module Exceptions
  #
  # 부모 에러 클래스
  class Error < StandardError
    attr_reader :data

    def initialize(message = '', data = {})
      @data = data
      super message
    end
  end

  #
  # 400 Bad Request
  # 요청 파라미터가 잘못됨
  class BadRequest < Error
  end

  #
  # 401 Unauthorized
  # 유효하지 않은 token
  class Unauthorized < Error
  end

  #
  # 403 Forbidden
  # 요청 권한 없음
  class Forbidden < Error
  end

  #
  # 403 Forbidden
  # 이용권이 요구됨
  class PassRequired < Error
  end

  #
  # 404 Not Found
  # 요청한 데이터가 존재하지 않음
  class NotFound < Error
  end

  # 409
  # 비즈니스 로직에 위배됨
  class Conflict < Error
  end

  # 400
  # 유저 타입이 불일치
  class InvalidUserType < Error
  end
end
