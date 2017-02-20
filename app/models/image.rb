class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  validates :file, presence: true, if: "reference_path.nil?"
  validates :name, presence: true
  validates :file, file_size: { less_than_or_equal_to: 1.gigabytes },
                   file_content_type: { allow: ['image/jpeg', 'image/png'] }

  before_save do
    if attribute_present?("reference_path")
      if !new_record?
        self.update_column :file, nil
      end
    elsif attribute_present?("file")
      self.update_column :reference_path, nil
    end
  end

  mount_uploader :file, ImageUploader

  self.per_page = 12

  default_scope  { order(created_at: :desc) }
end
