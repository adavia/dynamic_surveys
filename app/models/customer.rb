class Customer < ApplicationRecord
  belongs_to :user

  has_many :surveys, dependent: :destroy
  has_many :roles, dependent: :delete_all
  has_many :submissions, as: :sender

  validates :name, presence: true, length: { minimum: 4, maximum: 250 }

  validates :avatar, file_size: { less_than_or_equal_to: 2.gigabytes },
                     file_content_type: { allow: ['image/jpeg', 'image/png'] }

  scope :excluding_archived, -> { where(archived_at: nil).order(created_at: :desc) }

  has_secure_password

  self.per_page = 12

  mount_uploader :avatar, ImageUploader

  before_validation { self.password = "#{self.name[0..3].downcase.gsub(/\s+/, "")}123" }

  # Assign an API key on create
  before_create do |customer|
    last_id = Customer.last.id + 1 unless Customer.last.nil?
    customer.username = "#{SecureRandom.hex(3)}#{(last_id || rand(6))}"
    customer.api_key = customer.generate_api_key
  end

  def to_s
    "#{name}"
  end

  def has_member?(user)
    roles.exists?(user_id: user)
  end

  [:editor, :viewer].each do |role|
    define_method "has_#{role}?" do |user|
      roles.exists?(user_id: user, role: role)
    end
  end

  # Check archived user before log in
  def active_for_authentication?
    archived_at.nil?
  end

  # Archive customer
  def archive
    self.update_column :archived_at, Time.now
  end

  def self.search(search)
    where("name ILIKE ?", "%#{search}%").or(where("description ILIKE ?", "%#{search}%"))
  end

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless Customer.exists?(api_key: token)
    end
  end
end
