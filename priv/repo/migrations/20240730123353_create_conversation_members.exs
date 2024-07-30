defmodule ChatBridge.Repo.Migrations.CreateConversationMembers do
  use Ecto.Migration

  def change do
    create table(:conversation_members) do
      add :owner, :boolean, default: false, null: false
      add :conversation_id, references(:conversations, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:conversation_members, [:conversation_id])
    create index(:conversation_members, [:user_id])
    create unique_index(:conversation_members, [:conversation_id, :user_id])
  end
end
