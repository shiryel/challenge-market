# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Market.Repo.insert!(%Market.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Market.Accounts

Accounts.create_user(%{
  name: "vinicius",
  email: "vinicius@hotmail.com",
  password: "test"
})

# Just for me to remember that you can use too:
# Argon2.add_hash("test")[:password_hash]
