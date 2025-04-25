FROM ruby:3.2.8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential cron libpq-dev nodejs yarn

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} appuser && \
    useradd -u ${USER_ID} -g appuser -m appuser && \
    chown -R appuser:appuser /usr/local/bundle

WORKDIR /app

RUN chown appuser:appuser /app

USER appuser

RUN gem install bundler -v 2.6.5

COPY --chown=appuser:appuser Gemfile Gemfile.lock package.json yarn.lock ./

RUN bundle install

RUN yarn install --check-files

EXPOSE 3000
