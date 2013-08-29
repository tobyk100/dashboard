class Game < ActiveRecord::Base
  has_many :levels

  def video?
    self.name == 'Video'
  end
end
