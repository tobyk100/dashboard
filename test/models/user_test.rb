require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "validations" do
    good_data = { email: 'foo@bar.com', password: 'foosbars', username: 'user.12-34', name: 'tester'}

    user = User.create(good_data.merge({email: 'foo@bar'}))
    assert user.errors.messages.length == 1

    user = User.create(good_data.merge({username: 'tiny'}))
    assert user.errors.messages.length == 1

    user = User.create(good_data.merge({username: 'superreallydoublelongusername'}))
    assert user.errors.messages.length == 1

    user = User.create(good_data.merge({username: 'bo gus'}))
    assert user.errors.messages.length == 1

    user = User.create(good_data)
    #puts user.errors.messages.inspect
    assert user.errors.messages.length == 0

    user = User.create(good_data.merge({email: 'FOO@bar.com', username: 'user.12-35'}))
    assert user.errors.messages.length == 1, "Email should be rejected as a dup"

    user = User.create(good_data.merge({email: 'OTHER@bar.com', username: 'USER.12-34'}))
    assert user.errors.messages.length == 1, "Email should be rejected as a dup"
  end
end
