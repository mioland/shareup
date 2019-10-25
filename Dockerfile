FROM ruby:2.6.2

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client

RUN mkdir /shareup
WORKDIR /shareup
ADD Gemfile /shareup/Gemfile
ADD Gemfile.lock /shareup/Gemfile.lock
RUN bundle install
COPY . /shareup

CMD ["rails", "server", "-b", "0.0.0.0"]