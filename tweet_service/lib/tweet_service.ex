defmodule TweetService do
  @moduledoc """
  Documentation for `TweetService`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TweetService.hello()
      :world

  """
end

defmodule TweetService.Router do
  use Plug.Router

  # In-memory storage for tweets
  @tweets Agent.start_link(fn -> %{} end)

  # Post a tweet route
  post "/tweet" do
    {:ok, body, conn} = read_body(conn)
    {name, conn} = get_req_header(conn, "name") |> List.first() |> String.trim()

    Agent.update(@tweets, fn tweets ->
      tweets = Map.update(tweets, name, [body], fn old_tweets -> [body | old_tweets] end)
      {:ok, tweets}
    end)

    send_resp(conn, 201, "Tweet posted")
  end

  # Retrieve tweets route
  get "/tweets/:name" do
    name = conn.params["name"]

    case Agent.get(@tweets, &Map.get(&1, name, [])) do
      [] ->
        send_resp(conn, 404, "No tweets found")

      tweets ->
        send_resp(conn, 200, Enum.join(tweets, "\n"))
    end
  end

 
end
