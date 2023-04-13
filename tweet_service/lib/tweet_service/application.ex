defmodule TweetService.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: TweetService.Router,
        options: [port: 4002]
      )
    ]

    opts = [strategy: :one_for_one, name: TweetService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
