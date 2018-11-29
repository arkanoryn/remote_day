FROM elixir:latest

LABEL maintainer="Pierre-Nicolas SORMANI <pierrenicolas.sormani@gmail.com>"

RUN mkdir /usr/src/backend
WORKDIR /usr/src/backend
COPY . /usr/src/backend/

RUN mix local.hex --force
RUN mix local.rebar --force

# to install phoenix, useful only on the first build
# RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

RUN mix deps.get
RUN mix compile

