class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  validates :file, presence: true
  validates :file, file_size: { less_than_or_equal_to: 1.gigabytes },
                   file_content_type: { allow: ['image/jpeg', 'image/png'] }

  mount_uploader :file, ImageUploader

  self.per_page = 12

  default_scope  { order(created_at: :desc) }
end
