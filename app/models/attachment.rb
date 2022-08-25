class Attachment < ApplicationRecord
  belongs_to :album

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: %r/\Aimage\/.*\z/
end
