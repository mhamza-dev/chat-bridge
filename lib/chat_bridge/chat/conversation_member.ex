defmodule ChatBridge.Chat.ConversationMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChatBridge.{Accounts.User, Chat.Conversation}

  schema "conversation_members" do
    field :owner, :boolean, default: false

    belongs_to :user, User
    belongs_to :conversation, Conversation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation_member, attrs) do
    conversation_member
    |> cast(attrs, [:owner, :user_id, :conversation_id])
    |> validate_required([:owner, :user_id, :conversation_id])
  end
end
