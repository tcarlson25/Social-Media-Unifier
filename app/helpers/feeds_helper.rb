module FeedsHelper
    
  def validate_twitter_response(t_response)
    if t_response.nil?
      flash[:notice] = 'Error posting tweet'
    else
      flash[:notice] = 'Successfully posted!'
    end
  end
    
  def process_image(image)
    File.open(Rails.root.join('app/assets/images', image.original_filename), 'wb') do |f|
      f.write(image.read)
    end
    image_path = File.join(Rails.root, 'app', 'assets', 'images', image.original_filename)
    response = @client.update_with_media(params[:post_content], File.new(image_path))
    FileUtils.rm(image_path) unless response.nil?
    validate_twitter_response(response)
    response
  end
    
  def process_images(images)
    image_paths = []
    images.each do |image|
      File.open(Rails.root.join('app/assets/images', image.original_filename), 'wb') do |f|
        f.write(image.read)
      end
      image_path = File.join(Rails.root, 'app', 'assets', 'images', image.original_filename)
      image_paths << image_path
    end
    if image_paths.size() > 4
        flash[:notice] = 'Do not upload more than 4 images at once'
    else
      media = image_paths.map { |filename| File.new(filename) }
      response = @client.update_with_media(params[:post_content], media)
      image_paths.each { |path| FileUtils.rm(path) } unless response.nil?
      validate_twitter_response(response) 
      response
    end
  end
  
  def process_text(text)
    if text.strip.empty?
      flash[:notice] = 'You cannot post an empty tweet'
    else
      response = @client.update(text)
      validate_twitter_response(response)
      response
    end
  end
    
end
