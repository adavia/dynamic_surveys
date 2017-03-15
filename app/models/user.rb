class User < ApplicationRecord
  has_many :customers, dependent: :destroy
  has_many :submissions, as: :sender
  has_many :roles

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 150 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :password
  validates :image, file_size: { less_than_or_equal_to: 2.gigabytes },
                    file_content_type: { allow: ['image/jpeg', 'image/png'] }

  has_secure_password

  scope :excluding_archived, -> { where(archived_at: nil).order(created_at: :desc) }

  self.per_page = 12

  # Assign an API key on create
  before_create do |user|
    user.api_key = user.generate_api_key
  end

  mount_uploader :image, ImageUploader

  def to_s
    "#{name} #{last_name}"
  end

  def admin_text
    if admin?
      "admin"
    else
      "user"
    end
  end

  # Archived user
  def archive
    self.update_column :archived_at, Time.now
  end

  # Check archived user before log in
  def active_for_authentication?
    archived_at.nil?
  end

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  # Check for customer permission role
  def role_on(customer)
    roles.find_by(customer_id: customer).try(:role)
  end
end
