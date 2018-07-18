module DownloadHelper

  TIMEOUT_IN_SEC = 5
  DOWNLOADS_PATH =  File.expand_path('../../', File.dirname(__FILE__)) + '/downloads'
  extend self

  def downloads
    Dir[DOWNLOADS_PATH]
  end

  def wait_for_file_download(file_extension)
    Timeout.timeout(TIMEOUT_IN_SEC) do
      sleep 1 until has_file_by_extension?(DOWNLOADS_PATH, file_extension)
    end
  end

  def downloaded_by_file_extension?(file_name, file_extension)
    file_full_path = get_file_full_path(DOWNLOADS_PATH + "/#{file_name}", file_extension)
    file_full_path.include?(file_name)
  end

  def clear_downloads_folder
    FileUtils.rm_r(DOWNLOADS_PATH) if File.exists?(DOWNLOADS_PATH)
    FileUtils::mkpath DOWNLOADS_PATH
  end
end