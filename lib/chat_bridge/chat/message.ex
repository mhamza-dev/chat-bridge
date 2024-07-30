defmodule ChatBridge.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChatBridge.{Accounts.User, Chat.Conversation}

  schema "messages" do
    field :body, :string

    belongs_to :user, User
    belongs_to :conversation, Conversation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :user_id, :conversation_id])
    |> validate_required([:body, :user_id, :conversation_id])
  end
end
