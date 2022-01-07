# README

## Report Generator Application

### This is a rails application created with a didactic purpose. The goal was to build and analyse asynchron processing in rails. It was used sidekiq as the job runner.

* Ruby version 3.0.3
* Rails version ">= 6.1.4.4"
* Docker Compose version 3.8
* Node version 16

* Gems added:
  - capybara
  - database_cleaner-active_record
  - factory_bot_rails
  - faraday
  - redis
  - rspec-rails
  - rubocop-rails
  - selenium-webdriver
  - sidekiq
  - simplecov
  - vcr

* Database
  - postgres:14.1-alpine

* Configuration/Initialization
  - This project uses Docker, docker installation procedure can be found on the official website (https://www.docker.com/). Another option is to install locally the dependencies (yarn, nodejs and ruby). From now on it's assumed that docker is being used. All prerequisites are in Dockerfile.
  - To run the project, follow the next steps.
    - Build an image running, in the computer terminal, inside the project folder, the command:
      - docker-compose build
    - Generate a container running, in the computer terminal, inside the project folder, the command:
      - docker-compose run --service-ports rails bash
    - Install dependencies running, in the container terminal, the command:
      - bundle install
    - Update the image (do it whenever new gems are installed, after running bundle install)
      - docker-compose build
    - enter 'exit' to close the container terminal
  - To execute the application:
    - run docker-compose up, in the computer terminal
    - go to your browser, access http://localhost:3000

* How to run the test suite
  - rspec