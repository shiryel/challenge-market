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
alias Market.Bottlers.{Provider, Pair, Bottler}

Accounts.create_user(%{
  name: "vinicius",
  email: "vinicius@hotmail.com",
  password: "test"
})

# Just for me to remember that you can use too:
# Argon2.add_hash("test")[:password_hash]

Market.Repo.insert!(%Provider{
  name: "CBOE",
  pairs: [
    %Pair{
      name: "EUR/GBP",
      bottlers:
        Enum.map(1..50, fn x ->
          %Bottler{
            price: Decimal.new(x * 1000),
            quantity: x * 1000,
            date: DateTime.truncate(DateTime.add(DateTime.utc_now(), -x * 10000, :second), :second)
          }
        end)
    },
    %Pair{
      name: "EUR/USD",
      bottlers:
        Enum.map(50..70, fn x ->
          %Bottler{
            price: Decimal.new(x * 1000),
            quantity: x * 1000,
            date: DateTime.truncate(DateTime.add(DateTime.utc_now(), -x * 10000, :second), :second)
          }
        end)
    },
    %Pair{
      name: "GBP/USD",
      bottlers:
        Enum.map(70..200, fn x ->
          %Bottler{
            price: Decimal.new(x * 1000),
            quantity: x * 1000,
            date: DateTime.truncate(DateTime.add(DateTime.utc_now(), -x * 10000, :second), :second)
          }
        end)
    }
  ]
})
