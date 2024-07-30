defmodule ChatBridge.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :title, :string
    field :is_group, :boolean, default: false
    field :max_members, :integer, default: 2

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:title, :is_group, :max_members])
    |> validate_required([:title, :is_group, :max_members])
  end
end
