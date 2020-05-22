defmodule CookpodWeb.AccountControllerTest do
  use CookpodWeb.AuthUserCase

  alias Cookpod.Users

  @moduletag basic_auth: true

  describe "GET /new" do
    test "it renders new page", %{conn: conn} do
      path = Routes.user_path(conn, :new)
      conn = get(conn, path)

      assert html_response(conn, 200) =~ "Please sign up"
    end
  end

  describe "create" do
    test "it creates user if params are valid", %{conn: conn} do
      path = Routes.user_path(conn, :create)
      valid_params = string_params_for(:user, %{email: "test@test.com"})

      conn = post(conn, path, %{"user" => valid_params})

      user = Users.get_user_by(email: "test@test.com")
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
      assert get_session(conn, :current_user_id) == user.id
    end

    test "it does not create user if params are invalid", %{conn: conn} do
      path = Routes.user_path(conn, :create)
      invalid_params = string_params_for(:user, %{password_confirmation: "test"})

      conn = post(conn, path, %{"user" => invalid_params})

      user = Users.get_user_by(email: "test@test.com")

      assert user == nil
      assert html_response(conn, 422) =~ "Please sign up"
    end
  end
end