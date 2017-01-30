class Doccex::PageElements::Image < String

  DEFAULT_DIMENSIONS = { w: 1270000, h: 228600 }

  # the image_file argument is the name of the image file. It must have been copied into
  # the tmp/docx/word/media directory before being passed in (opportunity for improvement here?)
  def initialize(context, image_file, properties)
    rels = context.instance_variable_get(:@rels)
    locals = {:rid => rels.next_id(:image, image_file), :index => rels.next_image_index }
    locals[:dimensions] = get_converted_dimensions(image_file, properties)
    locals[:align] = (properties[:align] or 'left')
    super context.render(:partial => 'doccex/image', :formats => [:xml], :locals => locals)
  end

  # based on http://stackoverflow.com/a/8083390
  def get_converted_dimensions(image_file, properties)
    width_px, height_px = get_dimensions(image_file)

    if width_px.nil? || height_px.nil?
      return DEFAULT_DIMENSIONS
    end

    dpi = 72 # assume dpi is 72 because it looks like there is no ability to get it via rmagick
    emus_per_inch = 914400
    emus_per_cm = 360000
    max_width_cm = 16.51
    max_height_cm = 25.70
    width_emus = width_px / dpi * emus_per_inch
    height_emus = height_px / dpi * emus_per_inch
    max_width_emus = (max_width_cm * emus_per_cm).to_i
    max_height_emus = (max_height_cm * emus_per_cm).to_i
    dxa_to_emus = 635 # https://startbigthinksmall.wordpress.com/2010/01/04/points-inches-and-emus-measuring-units-in-office-open-xml/

    # Scaling is for image_field
    if properties[:scale]
      scale = properties[:scale].to_i / 100.0
      width_emus *= scale
      height_emus *= scale
    end

    max_image_width_emus = properties[:max_width].present? ? properties[:max_width] * dxa_to_emus : nil

    if max_image_width_emus.present? && width_emus > max_image_width_emus
      offset_emus = 160 * dxa_to_emus
      ratio = height_emus / width_emus.to_f
      width_emus = max_image_width_emus - offset_emus
      height_emus = width_emus * ratio
    elsif width_emus > max_width_emus
      ratio = height_emus / width_emus.to_f
      width_emus = max_width_emus
      height_emus = width_emus * ratio
    end

    # Adjust image by height to have image moved to next page if many images in one field
    if height_emus > max_height_emus
      ratio = width_emus / height_emus.to_f
      height_emus = max_height_emus
      width_emus = height_emus * ratio
    end

    { w: width_emus.to_i, h: height_emus.to_i }
  end

  def get_dimensions(image_file)
    if Gem::Specification.find_by_name('rmagick')
      image = Magick::Image.ping(Rails.root.join(image_file)).first
      [image.columns, image.rows]
    else
      [nil, nil]
    end
  end
end
