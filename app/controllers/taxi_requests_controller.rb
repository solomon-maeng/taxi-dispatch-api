# frozen_string_literal: true

class TaxiRequestsController < ApplicationController
  before_action :authenticate_request

  def index
    # 인증 인가 테스트를 위한 골격 구현 코드
  end
end