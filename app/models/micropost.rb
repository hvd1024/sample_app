class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.model.con_max}
  validate  :picture_size
  scope :by_user_id, ->(id){where user_id: id}

  private
  def picture_size
    return unless picture.size > 5.megabytes
    errors.add(:picture, t("models.pic_mess"))
  end
end
