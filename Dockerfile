#base image to build upon
FROM ruby:2.4.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /RAILS_APP_NAME
WORKDIR /RAILS_APP_NAME

ADD Gemfile ./Gemfile

RUN bundle install

ADD . .
