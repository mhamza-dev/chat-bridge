defmodule ChatBridge.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChatBridge.Chat` context.
  """

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    {:ok, conversation} =
      attrs
      |> Enum.into(%{
        is_group: true,
        max_members: 42,
        title: "some title"
      })
      |> ChatBridge.Chat.create_conversation()

    conversation
  end

  @doc """
  Generate a conversation_member.
  """
  def conversation_member_fixture(attrs \\ %{}) do
    {:ok, conversation_member} =
      attrs
      |> Enum.into(%{
        owner: true
      })
      |> ChatBridge.Chat.create_conversation_member()

    conversation_member
  end
end
