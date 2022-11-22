#!/usr/bin/env bash
set -eux

# This file indicates that the project has already been setup,
# so we don't run migrations and other stuff on every container restart
INIT_FLAG_FILE=./tmp/.initflag

# update bundles
bundle install

# Skip the setup if the project is in production or has already been setup before
if [[ ! -f "$INIT_FLAG_FILE" ]]; then

    echo "Checking whether MySQL and DynamoDB are ready to accept connections..."

    while ! { nc -z mentee-app.mysql 3306; }; do
      echo "Database is not ready yet"
      sleep 1
    done

    echo "Running bundle exec rake db:drop"
    bundle exec rake db:drop

    echo "Running db:create"
    bundle exec rake db:create

    echo "Setting the environment to development"
    bin/rails db:environment:set RAILS_ENV="development"

    echo "Running migrate"
    bundle exec rake db:migrate

    # Create the file indicating that the project has already been setup
    touch ${INIT_FLAG_FILE}
else
    echo "Skipping the setup as the project has either already been setup or we're in production"
    echo "If you want to run the setup again, make sure to remove the ${INIT_FLAG_FILE} and set RAILS_ENV to something different from \"production\""
fi

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

bundle exec rails s -p 3000 -b '0.0.0.0'
