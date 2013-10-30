require 'digest/md5'

class LevelSource < ActiveRecord::Base
  belongs_to :level

  validates_length_of :data, :maximum => 20000

  def self.lookup(level, data)
    md5 = Digest::MD5.hexdigest(data)
    self.where(level: level, md5: md5).first_or_create do |ls|
      ls.data = data
    end
  end
end
