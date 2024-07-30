defmodule ChatBridge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChatBridgeWeb.Telemetry,
      ChatBridge.Repo,
      {DNSCluster, query: Application.get_env(:chat_bridge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChatBridge.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChatBridge.Finch},
      # Start a worker by calling: ChatBridge.Worker.start_link(arg)
      # {ChatBridge.Worker, arg},
      # Start to serve requests, typically the last entry
      ChatBridgeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatBridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatBridgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
