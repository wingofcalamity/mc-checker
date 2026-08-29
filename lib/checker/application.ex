defmodule Checker.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Checker.Router, options: [port: 6969]}
    ]

    opts = [strategy: :one_for_one, name: Checker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
