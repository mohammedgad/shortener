defmodule ShortenerWeb.Router do
  use ShortenerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShortenerWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/urls", UrlController
    get("/r/:slug", UrlController, :redirections)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShortenerWeb do
  #   pipe_through :api
  # end
end
