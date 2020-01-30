FROM bitwalker/alpine-elixir-phoenix:latest
RUN apk add --no-cache build-base
# Set exposed ports
EXPOSE 5000
ENV PORT=5000 MIX_ENV=dev

RUN mkdir /app
WORKDIR /app

# Cache elixir deps
ADD mix.exs mix.lock /app/
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
  npm install

COPY . .

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
  npm run deploy && \
  cd - && \
  mix do compile, phx.digest

LABEL maintainer="Mohammed Gad <mohammedgad7@gmail.com>"

USER default

CMD ["mix", "phx.server"]