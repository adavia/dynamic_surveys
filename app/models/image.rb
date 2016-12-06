class Image < ApplicationRecord
  belongs_to :question

  mount_uploader :file, ImageUploader
end
