class AuthenticatedUser

  attr_reader :id, :user_type

  def initialize(user_id, user_type)
    @id = user_id
    @user_type = user_type
  end
end
