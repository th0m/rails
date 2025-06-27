FROM ruby:3.2-alpine

WORKDIR /app

# Install minimal dependencies
RUN apk add --no-cache build-base yaml-dev

# Install Rails
RUN gem install rails --no-document

# Create minimal Rails app
RUN rails new . --minimal --skip-git --skip-bundle

# Add tzinfo-data gem for timezone support
RUN echo 'gem "tzinfo-data"' >> Gemfile

# Install dependencies
RUN bundle install

# Generate controllers
RUN rails generate controller Container show --skip-routes
RUN echo "Container ID: <%= params[:id] %>" > app/views/container/show.html.erb
RUN echo "Rails.application.routes.draw { get '/container/:id', to: 'container#show' }" > config/routes.rb

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
