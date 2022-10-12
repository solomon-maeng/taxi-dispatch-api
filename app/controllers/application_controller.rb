# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Exceptions

  rescue_from Exception do |e|
    error(e)
  end

  # 400
  # 파라미터가 잘못됨
  rescue_from Exceptions::BadRequest, ActiveRecord::RecordInvalid, ActionController::ParameterMissing, ArgumentError do |e|
    exception_handler e, :bad_request
  end

  # 401
  # 유효하지 않은 token
  rescue_from Exceptions::Unauthorized do |e|
    exception_handler e, :unauthorized
  end

  # 403
  # 요청 권한 없음
  rescue_from Exceptions::Forbidden do |e|
    exception_handler e, :forbidden
  end

  # 404
  # 존재하지 않음
  rescue_from Exceptions::NotFound, ActiveRecord::RecordNotFound do |e|
    exception_handler e, :not_found
  end

  # 409
  # 비즈니스 로직에 위배됨
  rescue_from Exceptions::Conflict, ActiveRecord::RecordNotDestroyed do |e|
    exception_handler e, :conflict
  end

  def exception_handler(e, status)
    render json: { message: e.message }, status:
  end

  def error(e)
    Rails.logger.error(e)

    render json: { message: '현재 요청사항을 처리할 수 없습니다. 잠시 후 다시 시도해주세요' }, status: :internal_server_error
  end

end
