class AddImagesColumnToAlbum < ActiveRecord::Migration[7.0]
  def change
    add_attachment :albums, :images
  end
end
