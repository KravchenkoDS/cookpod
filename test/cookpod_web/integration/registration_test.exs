defmodule CookpodWeb.RegistrationTest do
  use CookpodWeb.IntegrationCase, async: true

  @moduletag basic_auth: true

  test "register with valid params", %{conn: conn} do
    get(conn, Routes.user_path(conn, :new))
    |> follow_form(%{
      user: %{
        email: "test_email@test_server.com",
        password: "test_pass",
        password_confirmation: "test_pass"
      }
    })
    |> assert_response(
      status: 200,
      path: Routes.page_path(conn, :index),
      html: "Logged in as test_email@test_server.com"
    )
  end

  test "registration attempt with invalid parameters", %{conn: conn} do
    get(conn, Routes.user_path(conn, :new))
    |> follow_form(%{
      user: %{
        email: "test_email",
        password: "pass_test",
        password_confirmation: "pass_test"
      }
    })
    |> assert_response(
      status: 422,
      path: Routes.user_path(conn, :create),
      html: "Registration"
    )
  end
end