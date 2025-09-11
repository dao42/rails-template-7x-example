FROM ghcr.io/clacky-ai/rails-base-template:latest

COPY --chown=ruby:ruby Gemfile* ./
# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"
RUN bundle install

COPY --chown=ruby:ruby package.json package-lock.json ./
RUN npm install

ENV NODE_ENV="production" \
  PATH="${PATH}:/home/ruby/.local/bin:/node_modules/.bin:/usr/local/bundle/bin" \
  USER="ruby" \
  PORT="3000" \
  SECRET_KEY_BASE="0952515e14cfe925a2ea3899eb2cc08cbc712bf14da9a569a9bcb1cf6d066eac7e43859b226c124e2ed08ea4f05ce43da229f2435f576e51f90d324e3e63a6c2"

WORKDIR /rails
# Copy application code
COPY --chown=ruby:ruby . .

RUN bundle exec rails assets:precompile

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
CMD ["./bin/rails", "server"]