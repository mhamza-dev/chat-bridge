defmodule ChatBridgeWeb.ConversationLive.Index do
  use ChatBridgeWeb, :live_view

  alias ChatBridge.Chat
  alias ChatBridge.Chat.Conversation

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: cu}} = socket) do
    {:ok,
     assign(
       socket,
       :conversations,
       Chat.list_conversations(cu.id) |> preload([:messages, members: [:user]])
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Conversation")
    |> assign(:conversation, Chat.get_conversation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Conversation")
    |> assign(:conversation, %Conversation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Conversations")
    |> assign(:conversation, nil)
  end

  @impl true
  def handle_info(
        {ChatBridgeWeb.ConversationLive.FormComponent, {:saved, conversation}},
        %{assigns: %{conversations: conversations}} = socket
      ) do
    {:noreply, assign(socket, :conversations, conversations ++ [conversation])}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, %{assigns: %{conversations: conversations}} = socket) do
    conversation = Chat.get_conversation!(id)
    {:ok, _} = Chat.delete_conversation(conversation)

    {:noreply,
     assign(socket, :conversations, Enum.filter(conversations, &(&1.id != conversation.id)))}
  end

  def split_groups(conversations) do
    Enum.split_with(conversations, fn conversation -> conversation.is_group end)
  end
end
