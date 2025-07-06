source "https://rubygems.org"
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [ :ruby ]
  gem "listen"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
gem "pg", ">= 1.1"
gem "figaro"
gem "slim-rails"
gem "high_voltage", "~> 3.1"
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "propshaft", "~> 1.1.0"
gem "sidekiq", "~> 7"
gem "bcrypt"
gem "kaminari"
gem "rails-i18n", "~> 7.0.10"
gem "mina", "~> 1.2.2", require: false
gem "mina-ng-puma", ">= 1.4.0", require: false
gem "mina-multistage", require: false
gem "mina-sidekiq", require: false
gem "mina-logs", require: false

group :development do
  gem "rails_apps_testing"
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
end

group :test do
  gem "database_cleaner"
  gem "launchy"
end