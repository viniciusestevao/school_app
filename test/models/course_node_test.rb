require "test_helper"

class CourseNodeTest < ActiveSupport::TestCase
  test "activity nodes require activity details" do
    node = courses(:one).course_nodes.build(title: "Avaliação", kind: :activity)

    assert_not node.valid?
    assert_includes node.errors[:activity], "é obrigatória para nós do tipo atividade"
  end

  test "non-activity nodes cannot retain activity details" do
    node = course_nodes(:one)
    node.kind = :container

    assert_not node.valid?
    assert_includes node.errors[:activity], "só pode existir em nós do tipo atividade"
  end
end
