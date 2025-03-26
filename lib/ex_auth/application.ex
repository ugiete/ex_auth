defmodule ExAuth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExAuthWeb.Telemetry,
      ExAuth.Repo,
      {DNSCluster, query: Application.get_env(:ex_auth, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExAuth.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ExAuth.Finch},
      # Start a worker by calling: ExAuth.Worker.start_link(arg)
      # {ExAuth.Worker, arg},
      # Start to serve requests, typically the last entry
      ExAuthWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExAuth.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExAuthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
