FROM ruby:3.0.3

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client


COPY Gemfile Gemfile.lock ./

RUN gem install bundler
RUN gem install rails
RUN bundle check || bundle install

COPY package.json ./
RUN npm install

COPY . ./

WORKDIR /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 1149

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
