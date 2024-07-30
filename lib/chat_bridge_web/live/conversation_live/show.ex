defmodule ChatBridgeWeb.ConversationLive.Show do
  use ChatBridgeWeb, :live_view
  require Logger

  alias ChatBridge.Chat
  alias ChatBridge.Chat.Message
  alias ChatBridgeWeb.Endpoint

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    Endpoint.subscribe("conversation-" <> id)
    conversation = Chat.get_conversation!(id) |> preload(messages: [:user], members: [:user])

    {:noreply,
     socket
     |> assign(
       page_title: page_title(socket.assigns.live_action),
       conversation: conversation,
       messages: Enum.sort_by(conversation.messages, & &1.inserted_at, :asc),
       changeset: Chat.change_message(%Message{})
     )}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      %Message{}
      |> Chat.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event(
        "send",
        %{"message" => message_params},
        %{assigns: %{conversation: conversation}} = socket
      ) do
    case Chat.create_message(message_params) do
      {:ok, new_message} ->
        Endpoint.broadcast!(
          "conversation-" <> to_string(conversation.id),
          "new_message",
          new_message
        )

        {:noreply, socket}

      {:error, err} ->
        Logger.error(err)
        {:noreply, put_flash(socket, :error, "Sorry, couldn't send message")}
    end
  end

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket) do
    updated_messages = socket.assigns[:messages] ++ [new_message |> preload(:user)]

    {:noreply, socket |> assign(:messages, updated_messages)}
  end

  defp page_title(:show), do: "Show Conversation"
  defp page_title(:edit), do: "Edit Conversation"
end
