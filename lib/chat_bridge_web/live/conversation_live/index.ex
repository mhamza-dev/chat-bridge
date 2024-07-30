defmodule ChatBridgeWeb.ConversationLive.Index do
  use ChatBridgeWeb, :live_view

  alias ChatBridge.Chat
  alias ChatBridge.Chat.Conversation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :conversations, Chat.list_conversations())}
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
  def handle_info({ChatBridgeWeb.ConversationLive.FormComponent, {:saved, conversation}}, socket) do
    {:noreply, stream_insert(socket, :conversations, conversation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    conversation = Chat.get_conversation!(id)
    {:ok, _} = Chat.delete_conversation(conversation)

    {:noreply, stream_delete(socket, :conversations, conversation)}
  end
end
