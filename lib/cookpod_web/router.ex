defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler
  import Plug.BasicAuth



  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :basic_auth, username: "admin", password: "secret"
  end

  pipeline :protected do
    plug CookpodWeb.AuthPlug
  end  

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/sessions", SessionController, singleton: true
    resources "/users", UserController, only: [:create, :new]
    resources "/recipes", RecipeController

    resources "/products", ProductController
    resources "/ingredients", IngredientController    
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    get "/terms", PageController, :terms
  end  

  scope "/api", CookpodWeb.Api, as: :api do
    pipe_through :api
    resources "/recipes", RecipeController, only: [:index, :show]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :cookpod, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Cookpod"
      },
      basePath: "/api"
    }
  end 

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("404.html")
  end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.ActionClauseError{}}) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("422.html")
  end


  def handle_errors(conn, _) do
    conn
  end
end
