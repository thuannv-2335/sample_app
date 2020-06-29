class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content_max}
  validates :image, size: {less_than: Settings.micropost.size_less.megabytes, message: I18n.t("micropost.size_less_than")}

  scope :recent_posts, -> {order created_at: :desc}
  scope :feed_user, -> user_id {where "user_id IN (?)", user_id}

  delegate :name, to: :user, prefix: :user

  def display_image
    image.variant resize_to_limit: [Settings.micropost.resize_to_limit, Settings.micropost.resize_to_limit]
  end
end
