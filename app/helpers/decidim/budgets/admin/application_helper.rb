# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      module Admin
        # Custom helpers, scoped to the budgets admin engine.
        #
        module ApplicationHelper
          include Decidim::Admin::ResourceScopeHelper
        end
      end
    end
  end
end
