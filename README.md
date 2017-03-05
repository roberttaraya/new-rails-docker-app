## Create and Run a Rails App using Docker
This sets up a Ruby on Rails 5.0.2 app using Docker and Docker-Compose to pull in docker images of Ruby 2.4.0 and MySQL 5.7.

### To Use:


1. Clone this repo using a new repo name

  `git clone git@github.com:roberttaraya/new-rails-docker-app.git RAILS_APP_NAME`

1. cd into the new directory

  `cd RAILS_APP_NAME`

1. Update the Dockerfile and docker-compose.yml with your rails app name

  ```
  #base image to build upon
  FROM ruby: 2.4.0

  RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

  RUN mkdir /RAILS_APP_NAME
  WORKDIR /RAILS_APP_NAME

  ADD Gemfile ./Gemfile

  RUN bundle install

  ADD . .
  ```

  ```
  version: "2"
  services:
    db:
      image: mysql:5.7
      restart: always
      environment:
        MYSQL_ROOT_PASSWORD: password
        MYSQL_DATABASE: RAILS_APP_NAME
        MYSQL_USER: appuser
        MYSQL_PASSWORD: password
      ports:
        - "3307:3306"
    app:
      build: .
      command: bundle exec rails s -p 3000 -b "0.0.0.0"
      volumes:
        - ".:/RAILS_APP_NAME"
      ports:
        - "3001:3000"
      depends_on:
        - db
      links:
        - db
      environment:
        DB_USER: root
        DB_NAME: RAILS_APP_NAME
        DB_PASSWORD: password
        DB_HOST: db
  ```

1. Create new Rails app using docker-compose command

  `
  docker-compose run app rails new . --force --database=mysql --skip-bundle
  `

1. Modify rails app database.yml file

  ```
  default: &default
    adapter: mysql2
    encoding: utf8
    pool: 5
    username: <%= ENV['DB_USER'] %>
    password: <%= ENV['DB_PASSWORD'] %>
    host: <%= ENV['DB_HOST'] %>
    database: <%= ENV['DB_NAME'] %>

  development:
    <<: *default

  test:
    <<: *default

  production:
    <<: *default
  ```

1. Rebuild docker image

  `docker-compose build`

1. Start services

  `docker-compose up`

1. Create your rails app, as usual...


### Common commands

`docker-compose run --rm app rake db:create`

`docker-compose run --rm app rake db:migrate`

`docker-compose run --rm app rails g scaffold`

#### https://www.youtube.com/watch?v=a-jcTib9ZPA&t=3s
