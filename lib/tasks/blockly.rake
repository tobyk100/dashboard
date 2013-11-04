require 'fileutils'

namespace :blockly do

  def npm_project
    'blockly-mooc'
  end

  def npm_root
    "https://registry.npmjs.org/#{npm_project}"
  end

  def npm_file(version)
    "#{npm_root}/-/#{npm_project}-#{version}.tgz"
  end

  def dest
    'public/blockly'
  end

  def clean!
    if File.symlink?(dest)
      File.unlink(dest)
    else
      FileUtils.rm_rf(dest)
    end
    FileUtils.rm_rf('.cache_bust')
  end

  task latest: :environment do
    puts "Asking #{npm_root} for latest version number"
    metadata = `curl --silent --insecure #{npm_root}`
    latest = metadata.scan(/"latest":"(.*?)"/)[0][0]
    puts "Latest version: #{latest}"
    Rake::Task['blockly:get'].invoke(latest)
  end

  task :get, [:version] => :environment do |t, args|
    clean!
    filepath = npm_file(args[:version])
    puts "Downloading and extracting #{filepath}"
    curl_cmd = "curl --silent --insecure #{filepath}"
    dirname = File.dirname(dest)
    tar_cmd = "tar -xz -C #{dirname}"
    `#{curl_cmd} | #{tar_cmd}`
    FileUtils.mv("#{dirname}/package", dest)
    File.open('.cache_bust', 'w') { |f| f.write(args[:version]) }
  end

  task :dev, [:src] => :environment do |t, args|
    src = args[:src]
    unless src
      raise 'Expected argument: path to blockly mooc source.'
    end
    fullsrc = "#{File.absolute_path(src)}/dist"
    unless File.directory?(fullsrc)
      raise "No such directory: #{fullsrc}"
    end
    clean!
    File.symlink(fullsrc, dest)
  end

end
