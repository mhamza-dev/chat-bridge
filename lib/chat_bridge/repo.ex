defmodule ChatBridge.Repo do
  use Ecto.Repo,
    otp_app: :chat_bridge,
    adapter: Ecto.Adapters.Postgres
end
