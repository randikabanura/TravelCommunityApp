class Trip < ApplicationRecord
  validates :location, presence: true
  validates :date_s, :date_e, presence: true
  validate :image_type, if: :location_changed?

  def thumbnail(size1 =100, size2= 100)
    if !self.photos.present?
    return self.photos.variant(resize: "#{size1}x#{size2}!").processed
    end
  end
  geocoded_by :location
  after_validation :geocode

  has_one_attached :photos
  belongs_to :user
  has_many :reviews, dependent: :delete_all
  resourcify

  def self.search(search)
    if search
      where('lower(location) LIKE ?', "%#{search}%").to_a
    else
      find(:all)
    end
  end

  def average_rating
    reviews = self.reviews
    if reviews.count > 0
      reviews.sum(:rating) / reviews.count
    else
      return 0
    end
  end

  private

  def image_type
    if photos.attached? == true
        if !photos.content_type.in?(%('image/jpeg image/png'))
          errors.add(:photos, 'needs to be a JPEG or PNG')
        end
    end
  end
end
