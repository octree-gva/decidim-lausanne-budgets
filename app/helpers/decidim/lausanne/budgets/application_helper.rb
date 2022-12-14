# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # Custom helpers, scoped to the budgets engine.
      #
      module ApplicationHelper
        include PaginateHelper
        include Decidim::Comments::CommentsHelper
        include ProjectsHelper
        include Decidim::CheckBoxesTreeHelper

        def filter_status_values
          TreeNode.new(
            TreePoint.new("", t("decidim.lausanne_budgets.projects.filters.status_values.all")),
            [
              TreePoint.new("selected", t("decidim.lausanne_budgets.projects.filters.status_values.selected")),
              TreePoint.new("not_selected", t("decidim.lausanne_budgets.projects.filters.status_values.not_selected"))
            ]
          )
        end
      end
    end
  end
end
