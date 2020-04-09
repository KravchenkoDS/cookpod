defmodule CookpodWeb.ViewHelpers do
  @moduledoc false
  import Plug.Conn, only: [get_session: 2]

  def user_logged_in?(conn) do
    not is_nil(get_session(conn, :current_user))
  end

  def get_current_user(conn) do
    case get_session(conn, :current_user) do
      nil ->
        "anonymous"
      current_user ->
        current_user
    end
  end
  
end