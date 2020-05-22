defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.AuthUserCase
  
  @moduletag basic_auth: true

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))

    assert html_response(conn, 200) =~ "Phoenix"
  end
end
