# frozen_string_literal: true

class AuthenticateUserProvider

  class << self
    def create(request)
      ins = new(request)
    end
  end

  def initialize(request)
    @processor = AuthenticateRequestProcessor.new
    @payload = request.headers[AUTHORIZATION_HEADER]
  end

  def user
    return
  end

  private

  AUTHORIZATION_HEADER = 'Authorization'

  USER_KEY = 'USER_KEY'
end
