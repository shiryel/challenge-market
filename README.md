# Market

![Test [CI]](https://github.com/shiryel/test-market/workflows/Test%20%5BCI%5D/badge.svg)
![Code quality [CI]](https://github.com/shiryel/test-market/workflows/Code%20quality%20%5BCI%5D/badge.svg)

A GraphQL API to see market analitics

## Dev run

`Tested with elixir version 1.10.4, OTP 23 and podman version 2.0.5`

```
# Install deps
mix deps.get

# Setup Postgres
podman run -d --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
mix ecto.setup

# Start server
mix phx.server
```

You can access the GraphQL API interface for tests in `http://localhost:4000/api`

## Docs

You can generate the docs with: `mix docs`

The GraphQL API docs can be found running in the Dev mode, on the `schema` right button

## GraphQL examples

### Login
```
mutation {
  login(email: "vinicius@hotmail.com", password: "test") {
    token
  }
}
```

Put the token on the HTTP Header as:

name | content
-----|--------
Authorization | Bearer ~TOKEN~

### Get current user info

(needs to be logged as the user)

```
query {
  me {
    email
    name
  }
}
```

### Full query example

(needs to be logged as the user)

```
query($filter: BottlerFilter!) {
  me {
    providers(page: 1, pageSize: 50, filterNames: ["CBOE"]) {
      name
	pairs(page: 1, pageSize: 20, filterNames: ["EUR/GBP", "EUR/USD", "GBP/USD"]) {
        name
        bottlers(page: 1, pageSize: 20, filter: $filter) {
          date
          price
          quantity
        }
      }
    }
  }
}
```

With the query variables:

```
{"filter": {"dateEnd": "2020-10-09T00:00:00Z"}}
```
