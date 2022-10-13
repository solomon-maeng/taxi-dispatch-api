# frozen_string_literal: true

class UsersController < ApplicationController

  def sign_in
    user = User.find_by(email: sign_in_params[:email])
    raise Exceptions::BadRequest, '아이디와 비밀번호를 확인해주세요' if user.nil?

    PasswordEncoder.new.decode(sign_in_params[:password], user.password_digest)
  end

  def sign_up
    params = sign_up_params

    encoder = PasswordEncoder.new

    user = User.create!(
      email: params[:email],
      password_digest: encoder.encode(params[:password]),
      user_type: params[:userType]
    )

    json_create_success UserSerializer.new(user).serialized_json
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    if e.message == '이미 가입된 이메일입니다'
      exception_handler e, :conflict
    else
      exception_handler e, :bad_request
    end
  end

  rescue_from ArgumentError do |e|
    e = Exceptions::BadRequest.new("올바른 userType을 입력해주세요") if e.message.include? "user_type"
    exception_handler e, :bad_request
  end
  
  private
  
  def sign_up_params
    params.require(%i(email password userType))
    params.permit(%i(email password userType))
  end

  def sign_in_params
    params.require(%i(email password))
    params.permit(%i(email password))
  end
end
