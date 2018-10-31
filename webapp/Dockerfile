FROM node:latest

LABEL maintainer="Pierre-Nicolas SORMANI <pierrenicolas.sormani@gmail.com>"

# set working directory
RUN mkdir /usr/src/frontend
WORKDIR /usr/src/frontend

# add `/usr/src/frontend/node_modules/.bin` to $PATH
ENV PATH /usr/src/frontend/node_modules/.bin:$PATH

# install and cache frontend dependencies
COPY package.json yarn.lock /usr/src/frontend/
RUN yarn

# add frontend
ADD . /usr/src/frontend

# start frontend
CMD ["yarn", "start"]
