# Shortener

To start your Shortener:

- docker-compose up --build
- docker-compose run --rm website mix do ecto.create, ecto.migrate

To run tests:

- docker-compose run --rm website bash
- MIX_ENV=test mix test

Now you can visit [`localhost:5000/urls`](http://localhost:5000/urls) from your browser.
To use the short link redirection [`localhost:5000/r/:slug`](http://localhost:5000/r/:slug)
