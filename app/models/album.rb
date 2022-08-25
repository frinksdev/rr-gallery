class Album < ApplicationRecord
  # has_attached_file :images, styles: { medium: "300x300>", thumb: "100x100>" }
  # validates_attachment_content_type :images, content_type: /\Aimage\/.*\z/
  has_many :attachments
  validates :title, presence: true
end
