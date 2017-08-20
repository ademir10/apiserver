# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

     process :resize_to_fit => [50, 50]


  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

   def extension_white_list
     %w(jpg jpeg gif png)
   end

end
