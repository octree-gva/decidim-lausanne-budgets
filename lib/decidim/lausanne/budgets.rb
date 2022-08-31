# frozen_string_literal: true

require "decidim/lausanne/budgets/current_user_record_middleware"
require "decidim/lausanne/budgets/workflows"
require "decidim/lausanne/budgets/admin"
require "decidim/lausanne/budgets/api"
require "decidim/lausanne/budgets/engine"
require "decidim/lausanne/budgets/admin_engine"
require "decidim/lausanne/budgets/component"

module Decidim
  module Lausanne
    # Base module for this engine.
    module Budgets
      autoload :ProjectSerializer, "decidim/lausanne/budgets/project_serializer"
    end
  end
end
