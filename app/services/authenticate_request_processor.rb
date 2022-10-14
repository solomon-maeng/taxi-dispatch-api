# frozen_string_literal: true

class AuthenticateRequestProcessor

  def initialize
    @parser = TokenParser.new
    @extractor = TokenExtractor.new
  end

  def authenticate(payload)
    result = @parser.parse(@extractor.extract(payload))
    user = User.find(id: result['user_id'])
    AuthenticatedUser.new(user.id, user.user_type)
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::NotFound, "존재하지 않는 회원입니다" if user.nil?
  end
end

class AuthenticatedUser

  attr_reader :id, :user_type

  def initialize(id, user_type)
    @id = id
    @user_type = user_type
  end
end
