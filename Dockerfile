FROM ruby:3.1.0

RUN apt-get update -qq  \
    && apt-get install -y \
    build-essential \
    libpq-dev nodejs \
    netcat

RUN mkdir "mentee-app"
WORKDIR "mentee-app"

COPY Gemfile /mentee-app/Gemfile
COPY Gemfile.lock /mentee-app/Gemfile.lock

COPY . /mentee-app
COPY docker-entrypoint-dev.sh /

ENTRYPOINT ["/./docker-entrypoint-dev.sh"]
