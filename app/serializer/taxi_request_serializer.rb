# frozen_string_literal: true

class TaxiRequestSerializer < BaseSerializer

  def serialized_hash
    return unless m

    {
      id: m.id,
      address: m.address,
      driverId: m.driver_id,
      passengerId: m.passenger_id,
      status: m.status,
      createdAt: m.created_at,
      updatedAt: m.updated_at,
      acceptedAt: m.accepted_at
    }
  end
end
