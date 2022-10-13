# frozen_string_literal: true

class PasswordEncoder

  def encode(raw_password)
    BCrypt::Password.create(raw_password)
  end

  def decode(input_password, encoded_password)
    raise Exceptions::BadRequest, '비밀번호가 올바르지 않습니다' unless input_password == encoded_password
  end
end
