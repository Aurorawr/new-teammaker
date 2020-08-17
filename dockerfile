FROM ruby:latest

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 

ENV RAILS_ROOT /var/www/app_name
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
COPY Gemfile Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5 --without development test
COPY . .
RUN bundle exec rake assets:precompile
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]