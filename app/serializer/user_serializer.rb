# frozen_string_literal: true

class UserSerializer < BaseSerializer

  def serialized_hash
    return unless m

    {
      id: m.id,
      userType: m.user_type,
      createdAt: m.created_at,
      updatedAt: m.updated_at,
      email: m.email
    }
  end
end
