class UserLevel < ActiveRecord::Base
  belongs_to :user
  belongs_to :level

  def best?
    (best_result == Activity::BEST_PASS_RESULT)
  end

  def finished?
    (best_result >= Activity::MINIMUM_FINISHED_RESULT)
  end

  def passing?
    (best_result >= Activity::MINIMUM_PASS_RESULT)
  end
end
