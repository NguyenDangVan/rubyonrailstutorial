class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.models.maxsize_content}
  validate :picture_size

  scope :orderd_by_created, -> {order created_at: :desc}

  private

    def picture_size
      if picture.size > (Settings.models.byte_of_image).megabyte
        errors.add :picture, "should be less than 1MB"
      end
    end
end
