# frozen_string_literal: true

require "decidim/dev/common_rake"

def install_module(path)
  Dir.chdir(path) do
    # system("bundle exec rake decidim_vocacity_gem_tasks:install:migrations")
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

def prepare_database(app_path)
  # Remove previous existing db, and recreate one.
  disable_docker_compose = ENV.fetch("DISABLED_DOCKER_COMPOSE", "false") == "true"
  unless disable_docker_compose
    system("sudo docker-compose -f docker-compose.yml down -v")
    system("sudo docker-compose -f docker-compose.yml up -d --remove-orphans")
  end
  databaseYml = {
    "development" => {
      "adapter" => "postgresql",
      "encoding" => "unicode",
      "host" => ENV.fetch("DATABASE_HOST", "localhost"),
      "port" => ENV.fetch("DATABASE_PORT", "5432").to_i,
      "username" => ENV.fetch("DATABASE_USERNAME", "decidim"),
      "password" => ENV.fetch("DATABASE_PASSWORD", "TEST-insecure-password"),
      "database" => "decidim_dev"
    },
    "test" => {
      "adapter" => "postgresql",
      "encoding" => "unicode",
      "host" => ENV.fetch("DATABASE_HOST", "localhost"),
      "port" => ENV.fetch("DATABASE_PORT", "5432").to_i,
      "username" => ENV.fetch("DATABASE_USERNAME", "decidim"),
      "password" => ENV.fetch("DATABASE_PASSWORD", "TEST-insecure-password"),
      "database" => "decidim_test"
    }
  }
  config_file = File.expand_path("#{app_path}/config/database.yml", __dir__)
  File.open(config_file, "w") { |f| YAML.dump(databaseYml, f) }
  Dir.chdir("#{app_path}") do
     system("bundle exec rails db:create")
     system("bundle exec rails decidim_lausanne_budgets:install:migrations")
     system("bundle exec rails db:migrate")
   end
end

desc "Generates a dummy app for testing"
task :test_app do
  ENV["RAILS_ENV"] = "test"
  Bundler.with_original_env do
    generate_decidim_app(
      "spec/dummy",
        "--app_name",
        "decidim_test",
        "--path",
        "../..",
        "--skip_spring",
        "--demo",
        "--force_ssl",
        "false",
        "--locales",
        "en,fr,es"
    )
    prepare_database("spec/dummy")
  end
end

desc "Prepare for development"
task :prepare_dev do
  databaseYml = {
    "development" => {
      "adapter" => "postgresql",
      "encoding" => "unicode",
      "host" => ENV.fetch("DATABASE_HOST", "localhost"),
      "port" => ENV.fetch("DATABASE_PORT", "5432").to_i,
      "username" => ENV.fetch("DATABASE_USERNAME", "decidim"),
      "password" => ENV.fetch("DATABASE_PASSWORD", "TEST-insecure-password"),
      "database" => "#{base_app_name}_development_app_development",
    }
  }
  config_file = File.expand_path("development_app/config/database.yml", __dir__)
  File.open(config_file, "w") { |f| YAML.dump(databaseYml, f) }
end

desc "Generates a development app"
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end

  system("bin/rails generate doorkeeper:install")
  system("bin/rails generate doorkeeper:migration")

  install_module("development_app")
  Rake::Task["prepare_dev"].invoke
  seed_db("development_app")
end
