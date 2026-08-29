defmodule Checker.Router do
  use Plug.Router
  alias Checker.Apps.Minecraft

  plug(:match)
  plug(:dispatch)

  get "/mc" do
    case Minecraft.check_mc("localhost", 25565) do
      {:ok, data} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, data)

      {:error, :timeout} ->
        conn
        |> send_resp(503, "timeout")

      {:error, reason} ->
        conn
        |> send_resp(503, "#{reason}")
    end
  end

  get "/" do
    send_resp(conn, 200, "Hello World")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
