# Remote Day
> A simple dashboard that inform the team of whom is working remotely on which day.

## Development
### Requirements
* [Docker](https://www.docker.com/get-started)

### Setup
1. run `docker-compose up --build` - this will build the docker images required for the project.
2. run `docker-compose run api-dev mix deps.get` - this will fetch the required dependencies for the backend.
3. run `docker-compose run api-dev mix ecto.setup` - this will create the database required for the backend _(Needs to be done on the first deployment)_.
4. run `docker-compose up` - this will create the images for both the backend (`api-dev`) and the frontend (`react-dev`).
Add the flag `-d` to run the apps in the background.

### Starting the servers
#### All-in-one solution
```shell
$> docker-compose up            # will start all the applications and log the entries for each of them on the terminal
$> docker-compose up -d         # will start the applications in the background
$> docker-compose logs SERVICE  # displays the logs of SERVICE (see [./docker-compose-yml](./docker-compose-yml) for services' name) [$> docker-compose logs -h to list the flags]
```

#### Running the backend only
```shell
$> docker-compose up api-dev
```

#### Running the frontend only
```shell
$> docker-compose up react-dev
```

#### Running the tests
```shell
$> docker-compose run -e "MIX_ENV=test" api-dev mix coveralls # will run the tests suit and the coverage for the backend
```

During development, it gets tiring/time consuming to use this command. If you've got a local setup, you can use `test.watch`
```shell
$> source api/.env # env variables required to run the test env
$> MIX_ENV=test mix ecto.setup
$> mix test.watch
```

### Dev notes
* The URL for the backend is [http://localhost:4000/](http://localhost:4000/)
* The URL for the request is [http://localhost:4000/v1](http://localhost:4000/)
* GraphiQL is accessible via [http://localhost:4000/test/graphiql](http://localhost:4000/test/graphiql)
* The application is accessible via [http://localhost:3337/](http://localhost:3337/)
* In React, the environment variable are accessible under the app via `process.env` and should be prefixed with `REACT_APP_`.
In Elixir you need to use `System.get_env("VAR_NAME")`.

### Prod notes
* Secret and dev env variables need to be put in the PROD env.

#### Staging/Prod
Note for myself: see [https://mherman.org/node-workshop/slides/react-docker/#55](https://mherman.org/node-workshop/slides/react-docker/#55) for further details.

