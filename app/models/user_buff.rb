class UserBuff < ApplicationRecord
  belongs_to :user

  # Scopes for active buffs
  scope :active, -> { where(active: true) }

  # Callback to deactivate expired buffs
  before_save :check_expiry


  def activate
    update(active: true)
  end

  def deactivate
    update(active: false)
  end

  def decrement_duration
    return unless active && duration.present?

    self.duration -= 1
    self.active = false if duration <= 0
    save
  end

  private

  def check_expiry
    if duration.present? && duration <= 0
      self.active = false
    end
  end
end
