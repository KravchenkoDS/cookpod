defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.AuthUserCase

  import Plug.Conn
  import Plug.Test

  import Cookpod.Factory

  @moduletag basic_auth: true

  describe "index" do
    test "GET /sessions not authenticated", %{conn: conn} do
      conn = get(conn, "/sessions")

      assert html_response(conn, 200) =~ "You are not logged in"
    end

    test "GET /sessions authenticated", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{current_user: "test@test.com"})
        |> get(Routes.session_path(conn, :show))

      assert html_response(conn, 200) =~ "You are logged in as test@test.com"
    end

    @tag authenticated_user: true
    test "GET /sessions with authenticated user", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :show))

      assert html_response(conn, 200) =~
               "You are logged in as #{get_session(conn, :current_user)}"
    end
  end

  test "GET /sessions/new", %{conn: conn} do
    conn = get(conn, "/sessions/new")

    assert html_response(conn, 200) =~ "New session"
  end

  describe "create session" do
    test "login with valid user", %{conn: conn} do
      user = insert(:user)
      path = Routes.session_path(conn, :create)
      valid_params = %{"email" => user.email, "password" => "test123"}

      conn =
        conn
        |> init_test_session(%{})
        |> post(path, %{user: valid_params})

      assert get_session(conn, :current_user) == user.email
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
    end

    test "login with invalid user", %{conn: conn} do
      user = insert(:user)
      path = Routes.session_path(conn, :create)
      invalid_params = %{"email" => user.email, "password" => "nvalid_pass"}

      conn =
        conn
        |> init_test_session(%{})
        |> post(path, %{user: invalid_params})

      assert html_response(conn, 422) =~ "invalid password"
    end
  end

  test "DELETE /sessions/delete", %{conn: conn} do
    path = Routes.session_path(conn, :delete)

    conn =
      conn
      |> init_test_session(%{current_user: "test@test.com"})
      |> delete(path)

    assert get_session(conn, :current_user) == nil
    assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
  end
end