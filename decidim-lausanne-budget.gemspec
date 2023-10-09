# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/lausanne/budgets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.version = Decidim::Lausanne::Budgets.version
  s.authors = ["Hadrien Froger"]
  s.email = ["hadrien@octree.ch"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-lausanne-budgets"
  s.summary = "Decidim budgets module"
  s.description = "A budgets component for decidim's participatory spaces."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "decidim-comments", Decidim::Lausanne::Budgets.decidim_version
  s.add_dependency "decidim-core", Decidim::Lausanne::Budgets.decidim_version
  s.add_dependency "kaminari", "~> 1.2", ">= 1.2.1"
  s.add_dependency "searchlight", "~> 4.1"
  s.add_dependency "social-share-button", "~> 1.2", ">= 1.2.1"

  s.add_development_dependency "decidim-admin", Decidim::Lausanne::Budgets.decidim_version
  s.add_development_dependency "decidim-dev", Decidim::Lausanne::Budgets.decidim_version
  s.add_development_dependency "decidim-proposals", Decidim::Lausanne::Budgets.decidim_version
end
