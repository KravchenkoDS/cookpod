defmodule CookpodWeb.LoginTest do
  use CookpodWeb.IntegrationCase

  setup %{conn: conn} do
    conn = with_valid_authorization_header(conn)
    user = insert(:user)

    %{conn: conn, user: user}
  end

  test "User login", %{conn: conn, user: user} do
    get(conn, Routes.page_path(conn, :index))
    |> follow_link("Log in")
    |> follow_form(%{
      user: %{
        email: user.email,
        password: user.password
      }
    })
    |> assert_response(
      status: 200,
      path: Routes.session_path(conn, :show, 1),
      html: "Logged in as #{user.email}"
    )
  end
end