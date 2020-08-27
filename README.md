# Market

![Test [CI]](https://github.com/shiryel/test-market/workflows/Test%20%5BCI%5D/badge.svg)
![Code quality [CI]](https://github.com/shiryel/test-market/workflows/Code%20quality%20%5BCI%5D/badge.svg)

A GraphQL API to see market analitics

## Dev run:

```
# Install deps
mix deps.get

# Setup Postgres
podman run -d --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
mix ecto.setup

# Start server
mix phx.server
```
