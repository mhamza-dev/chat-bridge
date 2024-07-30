defmodule ChatBridge.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :title, :string
      add :is_group, :boolean, default: false, null: false
      add :max_members, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
