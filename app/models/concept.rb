class Concept < ActiveRecord::Base
  has_and_belongs_to_many :levels
  belongs_to :video
  # Can't call static from filter. Leaving in place for fixing later
  #after_save :expire_cache

  def self.cached
    @@all_cache ||= Concept.all
  end

  def self.expire_cache
    @@all_cache = nil
  end
end
