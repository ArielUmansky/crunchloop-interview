# Demo
You can see it [here](https://github.com/user-attachments/assets/cfdfc582-3e7f-421e-ad83-9648feff9d80)
## Notes
 - Mobile first design. Even though some support for responsiveness was done, a big design change wasn't needed on vertical resolutions
 - This is not the final version. For sure there're things to do like editing fields, minor design details, etc, but I made the promise to deliver by today
### Complete All Feature Explanation
 - User clicks Complete All button on a TodoList show page
 - Button triggers a controller action that enqueues a Sidekiq job
 - Sidekiq job marks all items completed for that list using logic encapsulated and tested in the proper model
 - When done, the job broadcasts a Turbo Stream update
 - The browser receives the Turbo Stream, and updates the UI live (tasks mark completed and progress percentage updated)
 - User sees the updated list without refreshing

# rails-interview / TodoApi

[![Open in Coder](https://dev.crunchloop.io/open-in-coder.svg)](https://dev.crunchloop.io/templates/fly-containers/workspace?param.Git%20Repository=git@github.com:crunchloop/rails-interview.git)

This is a simple Todo List API built in Ruby on Rails 7. This project is currently being used for Ruby full-stack candidates.

## Build

To build the application:

`bin/setup`

## Run the API

To run the TodoApi in your local environment:

`bin/puma`

## Test

To run tests:

`bin/rspec`

Check integration tests at: (https://github.com/crunchloop/interview-tests)

## Contact

- Santiago Doldán (sdoldan@crunchloop.io)

## About Crunchloop

![crunchloop](https://s3.amazonaws.com/crunchloop.io/logo-blue.png)

We strongly believe in giving back :rocket:. Let's work together [`Get in touch`](https://crunchloop.io/#contact).

## Installation

### Setup Redis
This project uses Sidekiq with Redis as its queue database. Please make sure to have it installed:

```bash
# macOS (Homebrew):
brew install redis
```
```bash
# Ubuntu/Debian:
sudo apt update
sudo apt install redis-server
```

Start redis server:
```shell
sudo systemctl enable redis-server
sudo systemctl start redis-server
```
Verify Redis is running:
```shell
redis-cli ping  # Should return "PONG"
```
### Set Up the Database
Run the migrations to prepare your database.

```shell
bin/rails db:create db:migrate
```

## Cold Start
When you start your development machine and want to run the app, follow these steps:

1. Start Redis
```shell
redis-server
```
Or verify the redis service is up and running:
```shell
sudo systemctl status redis
```

2. Start Sidekiq
```shell
bundle exec sidekiq  # Run in a in its own terminal
```

3. Start the Rails Server
```shell
rails server
```
4. Access the App
Open http://localhost:3000 in your browser

### Notes
- Font Awesome icons are handled via the font-awesome-sass gem:
- Sidekiq Web UI (for job monitoring) can be enabled in routes.rb via ´/sidekiq´
