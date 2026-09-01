defmodule Checker.Router do
  use Plug.Router
  alias Checker.Apps.Minecraft

  plug(:match)
  plug(:dispatch)

  get "/mc/:port" do
    with {port, ""} <- Integer.parse(port),
         {:ok, data} <- Minecraft.check_mc("localhost", port) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, data)
    else
      {:error, :timeout} ->
        send_resp(conn, 503, "timeout")

      {:error, reason} ->
        send_resp(conn, 503, "#{reason}")

      _ ->
        send_resp(conn, 400, "invalid port")
    end
  end

  get "/" do
    send_resp(conn, 200, "Hello World")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
