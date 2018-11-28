# Remote Day <!-- omit in toc -->
> Working at an office is cool. Working remotely, from home or the coffee next
> door is better.
>
> Every day, people that would work remotely today, tomorrow or late this week
> send emails informing they will be working remotely. And every day, I would
> forget would is supposed to work remotely today, or is just coming late.
>
> What if there was a better way? ;)

## Status
> _This project is a side project done on my free time. It is currently under
> development until it reaches a satisfactory state to me._
>
> _You can have a look at the [`project board`](https://github.com/arkanoryn/remote_day/projects/1)
> to see what I expect to integrate further._
>
> -- @arkanoryn

## Table of Content
* [Status](#status)
* [Table of Content](#table-of-content)
* [Getting started](#getting-started)
  * [Requirements](#requirements)
    * [Containers](#containers)
    * [Local development](#local-development)
  * [Installation](#installation)
  * [Configurations](#configurations)
    * [Cronjob](#cronjob)
    * [Database](#database)
    * [Guardian](#guardian)
    * [Mailer / Bamboo](#mailer--bamboo)
    * [Phoenix](#phoenix)
* [Development](#development)
  * [Docker commands](#docker-commands)
  * [URLs](#urls)
  * [Env variables](#env-variables)
* [Tests](#tests)
  * [Elixir](#elixir)
    * [TDD](#tdd)
    * [Code syntax](#code-syntax)
    * [CI](#ci)
  * [React](#react)
    * [TDD](#tdd-1)
    * [Code syntax](#code-syntax-1)
    * [CI](#ci-1)
* [Production](#production)
* [Dependencies](#dependencies)
  * [Backend](#backend)
  * [Frontend](#frontend)
* [References](#references)
* [Author](#author)

## Getting started
> The application is separated into two. The `api` folder is an Elixir/Phoenix/Absinthe backend server while the `webapp` is a React-Redux app created with the create-react-app boilerplate.
>
> Both applications are docker containers. It is, therefore, possible to develop using only [Docker](https://www.docker.com/get-started).

### Requirements
#### Containers
* [Docker](https://www.docker.com/get-started)

#### Local development
* PostgreSQL
* NPM ~> 6.4.1 _(I guess)_ || yarn ~> 1.7.0
* Elixir ~> 1.7.4

### Installation
1. run `docker-compose up --build` - this will build the docker images required for the project.
2. run `docker-compose run api-dev mix deps.get` - this will fetch the required dependencies for the backend.
3. run `docker-compose run api-dev mix ecto.setup` - this will create the database required for the backend _(Needs to be done on the first deployment)_.
4. run `docker-compose up` - this will create the images for both the backend (`api-dev`) and the frontend (`react-dev`).
Add the flag `-d` to run the apps in the background.


### Configurations
Most of the credentials are fetched from the environment. See [docker-compose.yml](./docker-compose.yml) or [.env.example](./api/.env.example)

#### Cronjob
> Cronjobs are only started on `production` _(see [prod.exs](./api/config/prod.exs))_.

You can add a Cronjob by adding the following config:
```elixir
config :remote_day, RemoteDay.Scheduler,
  jobs: [
    # Every day at 9:30, do... See cronjob syntax for further details
    {"30 9 * * *", {RemoteDay.Jobs.MyJob, :my_func, [my_args]}}
  ]
```

#### Database
* `DB_ENV_POSTGRES_HOST`
* `DB_ENV_POSTGRES_USER`
* `DB_ENV_POSTGRES_PASSWORD`

#### Guardian
Guardian requires a secret key: `GUARDIAN_SECRET_KEY`

#### Mailer / Bamboo
Currently uses [`Bamboo.LocalAdapter`](https://github.com/thoughtbot/bamboo#adapters) and [`Bamboo.TestAdapter`](https://github.com/thoughtbot/bamboo#testing).

The `LocalAdapter` allows accessing a testing inbox. The inbox can be reached via: [http://localhost:4000/sent_emails](http://localhost:4000/sent_emails)

#### Phoenix
Phoenix requires an endpoint secret key: `ENDPOINT_SECRET_KEY`

## Development
### Docker commands
```shell
$> docker-compose up            # will start all the applications and log the entries for each of them on the terminal
$> docker-compose up -d         # will start the applications in the background
$> docker-compose up api-dev    # will start the api-dev container only (and dependencies)
$> docker-compose up react-dev  # will start the react-dev container only
$> docker-compose logs SERVICE  # displays the logs of SERVICE (see [./docker-compose-yml](./docker-compose-yml) for services' name) [$> docker-compose logs -h to list the flags]

$> # to run the tests suite and the coverage for the backend
$> docker-compose run -e "MIX_ENV=test" api-dev mix coveralls
```

### URLs
* The URL for the backend is: [http://localhost:4000/](http://localhost:4000/)
* The URL for the requests is: [http://localhost:4000/v1](http://localhost:4000/)
* GraphiQL is accessible via: [http://localhost:4000/test/graphiql](http://localhost:4000/test/graphiql)
* The web application is accessible via: [http://localhost:3337/](http://localhost:3337/)

### Env variables
> In React, the environment variables are accessible under the app via `process.env` and should be prefixed with `REACT_APP_`.
>
> In Elixir you need to use `System.get_env("VAR_NAME")`.

## Tests
### Elixir
#### TDD
As much as possible, I try to work using TDD, keeping the test suite up-to-date and acceptable
coverage.

> _During development, it is really time-consuming to start the docker-container again and again
> in order to run the tests suite._
>
> _I therefore decided to add the `test.watch` dependency in order to run my elixir-tests every time
> a file changes. Please note that you would need to add the env' variables from docker
> in your env. This solution unfortunately does not work with docker._
```shell
$> cd api

$> # The next command is required each time you swap from the docker env to the local env, and vice-versa
$> # I need to find a solution so that dependencies are not shared anymore between docker and local
$> rm _builds deps && mix deps.get

$>
$> cp .env.example .env

$> # add variables from .env to your shell env
$> source .env

$> # create the database, if it is not already set up
$> MIX_ENV=test mix ecto.create
$> mix test.watch --stale
```

#### Code syntax
> _The code syntax needs to match the official formatter one. I can only advise installing an
> auto-formatter to your IDE/editor if it is not already the case._

The code syntax is checked by [Hound](https://houndci.com/) on each pull-request.

#### CI
> To determine/configure

### React
#### TDD
> Currently, there is no test for the React App
>
> :o
>
> :|
>
> -_-"

> ... I know.

#### Code syntax
> Done by eslint, using the [.eslintrc config file](./webapp/.eslintrc.js). It is based on
> the Airbnb style guide. Originally. Based.
>
> _... yeah, before all the changes_

The code syntax is checked by [Hound](https://houndci.com/) on each pull-request.

#### CI
> To determine/configure

## Production
> Not production ready. No CI/CD prepared.


**Notes**
* Secrets and dev env variables need to be put in the PROD env.

## Dependencies
### Backend
* [Absinthe - GraphQL](https://absinthe-graphql.org/)
* [Bamboo - Mailing](https://github.com/thoughtbot/bamboo)
* [Coveralls - Test coverage](https://github.com/parroty/excoveralls)
* [Ex_Machina - Factories](https://github.com/thoughtbot/ex_machina)
* [Guardian - Authentication](https://github.com/ueberauth/guardian)
* [Phoenix Framework - HTTP server](https://phoenixframework.org/)
* [Quantum - CronJob](https://github.com/quantum-elixir/quantum-core)
* [Timex - Date manipulation](https://github.com/bitwalker/timex)
* ... see [mix.exs, `deps()`](./api/mix.exs)

### Frontend
* [Ant design](http://ant.design/)
* [Apollo - GraphQL client](apollographql.com)
* [Create react app - Boilerplate](https://github.com/facebook/create-react-app)
* [Lodash - for everything](https://lodash.com/docs/4.17.10)
* [React](https://reactjs.org/)
* [Redux](https://redux.js.org/)
* ... see [package.json#dependencies](./webapp/package.json)

## References
> During the development of the apps, I used some guides as examples. Here are
> those I kept as reference:
* [Docker initialization](https://mherman.org/node-workshop/slides/react-docker/#1)
* [Absinthe GraphQL - Dataloader setup and usage](https://github.com/emcasa/backend/)


## Author
* *Pierre-Nicolas SORMANI* - _Initial work_ - [@arkanoryn](http://github.com/arkanoryn/)
