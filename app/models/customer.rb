class Customer < ApplicationRecord
  belongs_to :user

  has_many :surveys, dependent: :destroy
  has_many :roles, dependent: :delete_all

  validates :name, presence: true, length: { minimum: 2, maximum: 250 }

  def has_member?(user)
    roles.exists?(user_id: user)
  end

  [:editor, :viewer].each do |role|
    define_method "has_#{role}?" do |user|
      roles.exists?(user_id: user, role: role)
    end
  end
end
