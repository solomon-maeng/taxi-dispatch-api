# frozen_string_literal: true

class PasswordEncoder

  def encode(raw_password)
    BCrypt::Password.create(raw_password)
  end

  def decode(input_password, encoded_password)
    raise Exceptions::BadRequest, '아이디와 비밀번호를 확인해주세요' unless input_password == encoded_password
  end
end
