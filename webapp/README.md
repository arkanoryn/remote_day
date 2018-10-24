# Remote day - Webapp

> This application has been created using `create-react-app`. You can view the default [README file here](./CREATE-REACT-APP_DOC.md).

## Development
### Requirements
* [Docker](https://www.docker.com/get-started)

### Running the server
```shell
$> docker-compose up -d --build
```

### Environment variable
You can add env variable via the [`docker-compose` file](./docker-compose-yml) under the `environment` variable.
You would then need to update the docker image using

```shell
$> docker-compose up -d
```

The environment variable are accessible under the app via `process.env` and should be prefixed with `REACT_APP_`.


## Staging/Prod
See [https://mherman.org/node-workshop/slides/react-docker/#55](https://mherman.org/node-workshop/slides/react-docker/#55) for further details.
