require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "public registration cannot assign the admin role" do
    assert_difference("User.count") do
      post user_registration_url, params: {
        user: {
          name: "Novo usuário",
          email: "new-user@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "admin"
        }
      }
    end

    assert User.last.member?
  end
end
