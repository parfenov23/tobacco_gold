module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_i)
        img = yield(img) if block_given?
        img
      end
    end
  end
end