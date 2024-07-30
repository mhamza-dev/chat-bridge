defmodule ChatBridge.ChatTest do
  use ChatBridge.DataCase

  alias ChatBridge.Chat

  describe "conversations" do
    alias ChatBridge.Chat.Conversation

    import ChatBridge.ChatFixtures

    @invalid_attrs %{title: nil, is_group: nil, max_members: nil}

    test "list_conversations/0 returns all conversations" do
      conversation = conversation_fixture()
      assert Chat.list_conversations() == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id" do
      conversation = conversation_fixture()
      assert Chat.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation" do
      valid_attrs = %{title: "some title", is_group: true, max_members: 42}

      assert {:ok, %Conversation{} = conversation} = Chat.create_conversation(valid_attrs)
      assert conversation.title == "some title"
      assert conversation.is_group == true
      assert conversation.max_members == 42
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation" do
      conversation = conversation_fixture()
      update_attrs = %{title: "some updated title", is_group: false, max_members: 43}

      assert {:ok, %Conversation{} = conversation} = Chat.update_conversation(conversation, update_attrs)
      assert conversation.title == "some updated title"
      assert conversation.is_group == false
      assert conversation.max_members == 43
    end

    test "update_conversation/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_conversation(conversation, @invalid_attrs)
      assert conversation == Chat.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{}} = Chat.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset" do
      conversation = conversation_fixture()
      assert %Ecto.Changeset{} = Chat.change_conversation(conversation)
    end
  end

  describe "conversation_members" do
    alias ChatBridge.Chat.ConversationMember

    import ChatBridge.ChatFixtures

    @invalid_attrs %{owner: nil}

    test "list_conversation_members/0 returns all conversation_members" do
      conversation_member = conversation_member_fixture()
      assert Chat.list_conversation_members() == [conversation_member]
    end

    test "get_conversation_member!/1 returns the conversation_member with given id" do
      conversation_member = conversation_member_fixture()
      assert Chat.get_conversation_member!(conversation_member.id) == conversation_member
    end

    test "create_conversation_member/1 with valid data creates a conversation_member" do
      valid_attrs = %{owner: true}

      assert {:ok, %ConversationMember{} = conversation_member} = Chat.create_conversation_member(valid_attrs)
      assert conversation_member.owner == true
    end

    test "create_conversation_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_conversation_member(@invalid_attrs)
    end

    test "update_conversation_member/2 with valid data updates the conversation_member" do
      conversation_member = conversation_member_fixture()
      update_attrs = %{owner: false}

      assert {:ok, %ConversationMember{} = conversation_member} = Chat.update_conversation_member(conversation_member, update_attrs)
      assert conversation_member.owner == false
    end

    test "update_conversation_member/2 with invalid data returns error changeset" do
      conversation_member = conversation_member_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_conversation_member(conversation_member, @invalid_attrs)
      assert conversation_member == Chat.get_conversation_member!(conversation_member.id)
    end

    test "delete_conversation_member/1 deletes the conversation_member" do
      conversation_member = conversation_member_fixture()
      assert {:ok, %ConversationMember{}} = Chat.delete_conversation_member(conversation_member)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_conversation_member!(conversation_member.id) end
    end

    test "change_conversation_member/1 returns a conversation_member changeset" do
      conversation_member = conversation_member_fixture()
      assert %Ecto.Changeset{} = Chat.change_conversation_member(conversation_member)
    end
  end
end
