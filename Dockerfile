FROM ruby:3.0

WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock

RUN bundle install


EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]