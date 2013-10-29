require 'fileutils'
require 'open-uri'

namespace :youtube do

  def thumbnail_url(youtube_id)
    "http://img.youtube.com/vi/#{youtube_id}/mqdefault.jpg"
  end

  def thumbnail_dir
    'public/c/video_thumbnails'
  end

  def download_thumbnail(video)
    src = thumbnail_url(video.youtube_code)
    dest = "#{thumbnail_dir}/#{video.id}.jpg"
    puts "Downloading #{src} to #{dest}"
    open(dest, 'wb') do |file|
      file << open(src).read
    end
  rescue
    puts "Error fetching thumbnail for video #{video.id}"
  end

  task :thumbnails => :environment do
    FileUtils.mkdir_p(thumbnail_dir)
    Video.all.find_each do |video|
      download_thumbnail(video)
    end
  end

end
