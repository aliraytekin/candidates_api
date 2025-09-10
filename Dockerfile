# Base image
FROM ruby:3.3.5

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential libpq-dev nodejs

# Create app directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose

# Copy rest of the app
COPY . .

# Expose Rails port
EXPOSE 3000

# Default command
CMD ["bash", "-c", "bundle exec rails db:create db:migrate && bundle exec rails s -b 0.0.0.0 -p 3000"]
