class Level < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :concepts
  #accepts_nested_attributes_for :concepts
end
