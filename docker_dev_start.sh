#!/bin/sh
cd /app
mix deps.get

#  banco de dados
mix ecto.drop
mix ecto.setup

# Phoenix
mix phx.server
