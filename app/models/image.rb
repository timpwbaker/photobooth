class Image < ApplicationRecord
  belongs_to :shoot
  has_attached_file :image, styles: {
    headshot: {
      geometry: "800x1200#", quality: 100, convert_options: '-brightness-contrast -10x30 -colorspace Gray'}}
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


end
