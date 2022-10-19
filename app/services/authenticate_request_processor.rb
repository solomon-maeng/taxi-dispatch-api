# frozen_string_literal: true

class AuthenticateRequestProcessor

  def initialize
    @parser = TokenParser.new
    @extractor = TokenExtractor.new
  end

  def authenticate(payload)
    result = @parser.parse(@extractor.extract(payload))
    user = User.find_by(id: result['user_id'])
    raise Exceptions::NotFound, '존재하지 않는 회원입니다' if user.nil?

    user
  end
end
