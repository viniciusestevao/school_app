require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "does not accept negative points" do
    activity = activities(:one)
    activity.points = -1

    assert_not activity.valid?
  end
end
