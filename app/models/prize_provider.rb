class PrizeProvider < ActiveRecord::Base
  has_many :prizes
  has_many :teacher_prizes
  has_many :teacher_bonus_prizes
end
