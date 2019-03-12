class Image < ApplicationRecord
  belongs_to :shoot
  has_attached_file :image, styles: {
    headshot: {geometry: "400x600#", quality: 100, convert_options: '-colorspace Gray'} }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


end
