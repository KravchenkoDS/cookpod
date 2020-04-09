defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase

  def with_valid_authorization_header(conn) do
    conn
    |> put_req_header("authorization", "Basic dXNlcjpzZWNyZXQ=")
  end  

  test "GET /sessions/new", %{conn: conn} do
    conn = conn
    |> with_valid_authorization_header()
    |> get("/sessions/new")    
    assert html_response(conn, 200) =~ "Log in"
  end
end