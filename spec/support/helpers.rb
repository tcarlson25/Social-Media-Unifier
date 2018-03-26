module Helpers
   
  def mock_archive_upload(archive_path, type)
    return ActionDispatch::Http::UploadedFile.new(:tempfile => File.new(Rails.root + archive_path , :type => type, :filename => File.basename(File.new(Rails.root + archive_path))))
  end
    
end