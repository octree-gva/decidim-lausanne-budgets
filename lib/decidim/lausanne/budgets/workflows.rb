# frozen_string_literal: true

require "decidim/lausanne/budgets/workflows/base"
require "decidim/lausanne/budgets/workflows/one"
require "decidim/lausanne/budgets/workflows/all"

module Decidim
  module Lausanne
    module Budgets
      # Public: Stores the array of available workflows
      def self.workflows
        @workflows ||= {
          one: Workflows::One,
          all: Workflows::All
        }
      end
    end
  end
end
