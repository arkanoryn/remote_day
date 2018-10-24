FROM node:latest

# set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json yarn.lock /usr/src/app/
RUN yarn

# add app
ADD . /usr/src/app

# start app
CMD ["yarn", "start"]
