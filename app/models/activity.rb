class Activity < ActiveRecord::Base
  MINIMUM_FINISHED_RESULT = 10
  MINIMUM_PASS_RESULT = 20
  BEST_PASS_RESULT = 100

  validates_length_of :data, :maximum => 16000

  belongs_to :level
  belongs_to :user

  def best?
    (test_result == BEST_PASS_RESULT)
  end

  def finished?
    (test_result >= MINIMUM_FINISHED_RESULT)
  end

  def passing?
    (test_result >= MINIMUM_PASS_RESULT)
  end
end
