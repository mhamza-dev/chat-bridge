# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChatBridge.Repo.insert!(%ChatBridge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ChatBridge.Accounts.User
alias ChatBridge.Chat
alias ChatBridge.Chat.Conversation
alias ChatBridge.Chat.ConversationMember
alias ChatBridge.Repo

password = "Pa$$w0rd!"

{:ok, %User{id: u1_id}} = Repo.insert(%User{email: "user1@gmail.com", password: password, hashed_password: Bcrypt.hash_pwd_salt(password), nickname: "user-one", confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)})
{:ok, %User{id: u2_id}} = Repo.insert(%User{email: "user2@gmail.com", password: password, hashed_password: Bcrypt.hash_pwd_salt(password), nickname: "user-two", confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)})

{:ok, %Conversation{id: conv_id}} = Chat.create_conversation(%{title: "Modern Talking"})

{:ok, %ConversationMember{}} =
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: u1_id, owner: true})

{:ok, %ConversationMember{}} =
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: u2_id, owner: false})
