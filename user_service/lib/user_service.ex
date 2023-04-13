defmodule UserService do
  @moduledoc """
  Documentation for `UserService`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> UserService.hello()
      :world

  """
  def hello do
    :world
  end
end

defmodule UserService.Router do
  use Plug.Router

  # In-memory storage for users
  @users Agent.start_link(fn -> %{} end)

  # User registration route
  post "/register" do
    {:ok, body, conn} = read_body(conn)
    {name, conn} = get_req_header(conn, "name") |> List.first() |> String.trim()

    case Agent.update(@users, fn users ->
           if Map.has_key?(users, name) do
             {:error, users}
           else
             {:ok, Map.put(users, name, body)}
           end
         end) do
      {:ok, _} ->
        send_resp(conn, 201, "User registered")

      {:error, _} ->
        send_resp(conn, 400, "Username already exists")
    end
  end

  
end
