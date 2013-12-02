class Concept < ActiveRecord::Base
  has_and_belongs_to_many :levels
  belongs_to :video
  after_save :expire_cache

  def self.cached
    @@all_cache ||= Concept.all
  end

  def self.expire_cache
    @@all_cache = nil
  end
end
