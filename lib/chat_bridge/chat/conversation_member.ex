defmodule ChatBridge.Chat.ConversationMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversation_members" do
    field :owner, :boolean, default: false
    field :conversation_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation_member, attrs) do
    conversation_member
    |> cast(attrs, [:owner])
    |> validate_required([:owner])
  end
end
