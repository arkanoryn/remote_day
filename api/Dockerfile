FROM elixir:latest

LABEL maintainer="Pierre-Nicolas SORMANI <pierrenicolas.sormani@gmail.com>"

RUN mkdir /usr/src/backend
WORKDIR /usr/src/backend

RUN mix local.hex --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

ADD . /usr/src/backend
