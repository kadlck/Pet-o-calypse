class User < ApplicationRecord
  has_many :pets, dependent: :destroy
  has_many :user_buffs
  has_many :rewards
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def apply_buffs_to_pet(pet)
    user_buffs.active.each do |buff|
      pet.apply_buff(buff)
    end
  end
end
