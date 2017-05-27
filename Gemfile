source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.0.3'
gem 'sqlite3'
gem 'puma', '3.8.2'

gem 'active_model_serializers', '0.10.0'
gem 'validates_timeliness', '4.0.2'

group :development, :test do
  gem 'byebug', '9.0.6', platform: :mri
  gem 'rspec-rails', '3.5.2'
  gem 'rubocop', '0.46.0', require: false
  gem 'bullet', '5.4.2'
end

group :development do
  gem 'listen', '3.0.8'
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'simplecov', '0.12.0', require: false
  gem 'database_cleaner', '1.5.3'
  gem 'ffaker', '2.2.0'
  gem 'shoulda-matchers', '3.1.1'
  gem 'factory_girl_rails', '4.7.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
