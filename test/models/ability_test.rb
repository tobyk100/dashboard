require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "as guest" do
    ability = Ability.new(User.new)

    assert ability.can?(:read, Provider)
    assert ability.can?(:read, Goal)
    assert ability.can?(:read, Activity)

    assert !ability.can?(:destroy, Provider)
    assert !ability.can?(:destroy, Goal)
    assert !ability.can?(:destroy, Activity)
  end

  test "as member" do
    ability = Ability.new(create(:user))

    assert ability.can?(:read, Provider)
    assert ability.can?(:read, Goal)
    assert ability.can?(:read, Activity)

    assert !ability.can?(:destroy, Provider)
    assert !ability.can?(:destroy, Goal)
    assert !ability.can?(:destroy, Activity)
  end

  test "as admin" do
    ability = Ability.new(create(:admin))

    assert ability.can?(:read, Provider)
    assert ability.can?(:read, Goal)
    assert ability.can?(:read, Activity)

    assert ability.can?(:destroy, Provider)
    assert ability.can?(:destroy, Goal)
    assert ability.can?(:destroy, Activity)
  end

end
