source 'https://rubygems.org'

ruby '2.6.3'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack-cors'
gem 'rails', '~> 5.2.3'

gem 'graphql', '~> 1.9'
gem 'graphql-docs'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'chronic_duration'
  gem 'factory_girl', '~> 4.8.1'
  gem 'faker'
  gem 'pry'
  gem 'pry-nav'
  gem 'uuidtools'
end

group :development do
  gem 'graphiql-rails'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'pg_tasks', git: 'https://github.com/drtom/rails_pg-tasks', branch: 'master_rails_5'
  gem 'rspec-rails'
  gem 'rspec-graphql_matchers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
