# frozen_string_literal: true

module RequestSpecHelper

  def valid_header(id)
    {
      'Authorization' => "Token #{generate_token(id)}"
    }
  end

  private

  def generate_token(user_id)
    TokenGenerator.new.generate(user_id:)
  end
end
