require "test_helper"

class CourseTest < ActiveSupport::TestCase
  test "requires a title" do
    assert_not Course.new(description: "Sem título").valid?
  end
end
