require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @course = courses(:one)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "member cannot get new" do
    get new_course_url
    assert_redirected_to root_url
  end

  test "member cannot create course" do
    assert_no_difference("Course.count") do
      post courses_url, params: { course: { description: @course.description, title: @course.title } }
    end
    assert_redirected_to root_url
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "member cannot get edit" do
    get edit_course_url(@course)
    assert_redirected_to root_url
  end

  test "member cannot update course" do
    patch course_url(@course), params: { course: { description: @course.description, title: @course.title } }
    assert_redirected_to root_url
  end

  test "member cannot destroy course" do
    assert_no_difference("Course.count") do
      delete course_url(@course)
    end
    assert_redirected_to root_url
  end

  test "admin can manage courses" do
    sign_out users(:one)
    sign_in users(:admin)

    get new_course_url
    assert_response :success

    assert_difference("Course.count") do
      post courses_url, params: { course: { description: "Descrição", title: "Novo curso" } }
    end

    assert_redirected_to courses_url
  end
end
