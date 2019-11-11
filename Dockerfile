FROM ruby:2.6.5-alpine

LABEL maintainer="Andrei Gladkyi <arg@arg.zone>"

RUN apk add --update build-base postgresql-client postgresql-dev tzdata

COPY . /app

WORKDIR /app

ENV PATH=/app/bin:$PATH

RUN gem install bundler -v '2.0.2'

RUN if [[ "$RAILS_ENV" == "production" ]]; then \
  bundle install --jobs 2 --retry 5 --without development test; \
else \
  bundle install --jobs 2 --retry 5; \
fi

RUN apk del build-base

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]

CMD ["rails", "server", "--binding=0.0.0.0", "--port=3000"]
