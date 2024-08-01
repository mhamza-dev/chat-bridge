defmodule ChatBridgeWeb.UserLoginLive do
  use ChatBridgeWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-screen mx-auto max-w-sm">
      <div class="mx-auto max-w-sm">
        <.header class="text-center">
          Log in to account
          <:subtitle>
            Don't have an account?
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            for an account now.
          </:subtitle>
        </.header>

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"}>
          <%= case @signin_through do %>
            <% "nickname" -> %>
              <.input
                field={@form[:nickname]}
                type="text"
                label="Nick Name"
                placeholder="i.e: john-doe"
                required
              />
            <% "email" -> %>
              <.input
                field={@form[:email]}
                type="email"
                label="Email"
                placeholder="i.e: john.doe@example.com"
                required
              />
          <% end %>
          <.input
            field={@form[:password]}
            type="password"
            label="Password"
            placeholder="Enter Password"
            required
          />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
              Forgot your password?
            </.link>
          </:actions>
          <p>
            Signed in through
            <span
              :if={@signin_through == "email"}
              phx-click="through_nickname"
              class="font-bold cursor-pointer hover:underline hover:text-blue-600"
            >
              Nick Name
            </span>
            <span
              :if={@signin_through == "nickname"}
              phx-click="through_email"
              class="font-bold cursor-pointer hover:underline hover:text-blue-600"
            >
              Email
            </span>
          </p>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, signin_assigns(socket, "email")}
  end

  def handle_event("through_" <> field, _, socket) do
    {:noreply, signin_assigns(socket, field)}
  end

  defp signin_assigns(socket, field) when is_binary(field) do
    flash_field = Phoenix.Flash.get(socket.assigns.flash, String.to_atom(field))
    form = to_form(%{field => flash_field}, as: "user")
    assign(socket, form: form, signin_through: field)
  end
end
