require "test_helper"

class CourseNodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
    @node = course_nodes(:one)
    sign_in users(:one)
  end

  test "member cannot access course structure" do
    get course_nodes_url(@course)
    assert_redirected_to root_url
  end

  test "admin can create a container node" do
    sign_out users(:one)
    sign_in users(:admin)

    assert_difference("CourseNode.count") do
      post course_nodes_url(@course), params: { course_node: { title: "Novo módulo", kind: "container" } }
    end

    assert_redirected_to edit_course_url(@course)
  end

  test "admin cannot move a node under one of its descendants" do
    sign_out users(:one)
    sign_in users(:admin)
    parent = @course.course_nodes.create!(title: "Módulo", kind: :container)
    child = @course.course_nodes.create!(title: "Filho", kind: :container, parent: parent)

    patch reparent_course_node_url(@course, parent), params: { parent_id: child.id }

    assert_redirected_to course_nodes_url(@course)
    assert_nil parent.reload.parent_id
  end
end
