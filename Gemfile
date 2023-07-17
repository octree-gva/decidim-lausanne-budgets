source "https://rubygems.org"
ruby RUBY_VERSION

base_path = "./"
base_path = "../../" if File.basename(__dir__) == "dummy"
base_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{base_path}lib/decidim/lausanne/budgets/version"

DECIDIM_VERSION = Decidim::Lausanne::Budgets.version

gem "decidim", "~> 0.26.4"
gem "decidim-lausanne-budgets", path: base_path
gem "kaminari", "~> 1.2", ">= 1.2.1"
gem "searchlight", "~> 4.1"
gem "rails", "6.0.6"
gem "rake", "13.0.6"
gem "puma", ">= 5.5.1"
gem "bootsnap", "~> 1.4"
gem "uglifier", "~> 4.1"

group :development, :test do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 4.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "4.0.4"  
  gem "rubocop", require: false
end

group :development do
  gem "decidim-dev", "~> 0.26.4"
end
