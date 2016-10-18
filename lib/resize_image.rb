class ResizeImage
  def self.crop(path)
    img = MiniMagick::Image.open(path)
    img.format "jpg"
    img_center = center(img, 256, 256)
    img.crop(img_center)
    img
  end

  def self.center(img, w, h)
    img_width = img[:width]
    img_height = img[:height]
    center_w = img_width/2
    center_h = img_height/2
    crop_w = center_w - (w/2)
    crop_h = center_h - (h/2)
    "#{w}x#{h}+#{crop_w}+#{crop_h}"
  end

  def self.course_image_resize(image, img_width, img_height)
    qtumb = img_width/img_height.to_f
    width = image.width
    height = image.height
    if (width/height.to_f) > qtumb
      remove = (width - height*qtumb)/2
      image.shave("#{remove}x0")
    else
      remove = (height - width/qtumb)/2
      image.shave("0x#{remove}")
    end
    image.resize("#{img_width}x#{img_height}")
  end
end