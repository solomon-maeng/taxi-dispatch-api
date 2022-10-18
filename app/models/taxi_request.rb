# frozen_string_literal: true

class TaxiRequest < ApplicationRecord

  enum status: { pending: 'pending', accepted: 'accepted' }

  validates :address, length: { maximum: 100 }, presence: true
  validates :status, inclusion: { in: TaxiRequest.statuses.keys }
  validates :driver_id, :passenger_id, presence: true

  def accepted_by(user)
    update!(driver_id: user.id, status: :accepted, accepted_at: Time.current)
  end
end
