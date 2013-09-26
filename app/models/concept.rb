class Concept < ActiveRecord::Base
  has_and_belongs_to_many :levels
  belongs_to :video
end
