class Customer < ApplicationRecord
  belongs_to :user

  has_many :surveys, dependent: :destroy
  has_many :roles, dependent: :delete_all

  validates :name, presence: true, length: { minimum: 2, maximum: 250 }

  scope :excluding_archived, -> { where(archived_at: nil).order(created_at: :desc) }

  self.per_page = 12

  def has_member?(user)
    roles.exists?(user_id: user)
  end

  [:editor, :viewer].each do |role|
    define_method "has_#{role}?" do |user|
      roles.exists?(user_id: user, role: role)
    end
  end

  # Archive customer
  def archive
    self.update_column :archived_at, Time.now
  end
end
