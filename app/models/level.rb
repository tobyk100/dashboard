class Level < ActiveRecord::Base
  belongs_to :game
  has_and_belongs_to_many :concepts
  #accepts_nested_attributes_for :concepts

  def videos
    ([game.intro_video] + concepts.map(&:video)).reject(&:nil?)
  end
end
