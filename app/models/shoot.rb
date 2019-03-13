class Shoot < ApplicationRecord
  belongs_to :event
  has_many :images, dependent: :destroy
end
