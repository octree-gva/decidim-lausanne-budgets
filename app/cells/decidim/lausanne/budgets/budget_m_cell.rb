# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # This cell renders the Medium (:m) budget card
      # for an given instance of a Decidim::Lausanne::Budgets::LausanneBudget
      class BudgetMCell < Decidim::CardMCell
        include ActiveSupport::NumberHelper
        include Decidim::Lausanne::Budgets::ProjectsHelper

        def statuses
          []
        end
      end
    end
  end
end
