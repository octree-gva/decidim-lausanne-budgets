# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # A helper to render order and budgets actions
      module ProjectsHelper
        # Render a budget as a currency
        #
        # budget - A integer to represent a budget
        def budget_to_currency(budget)
          number_to_currency budget, unit: Decidim.currency_unit, precision: 0
        end

        # Return a percentage of the current order budget from the total budget
        def current_order_budget_percent
          current_order&.budget_percent.to_f.floor
        end

        # Return the minimum percentage of the current order budget from the total budget
        def current_order_budget_percent_minimum
          return 0 if current_order.minimum_projects_rule?

          if current_order.projects_rule?
            (current_order.minimum_projects.to_f / current_order.maximum_projects)
          else
            component_settings.vote_threshold_percent
          end
        end

        def budget_confirm_disabled_attr
          return if current_order_can_be_checked_out? && voting_open? && current_order.valid?
          %( disabled="disabled" ).html_safe
        end

        # Return true if the current order is checked out
        delegate :checked_out?, to: :current_order, prefix: true, allow_nil: true

        # Return true if the user can continue to the checkout process
        def current_order_can_be_checked_out?
          current_order&.can_checkout?
        end
        def display_rules?
          !(user_record_submitted? || current_order.checked_out?)
        end

        def current_rule_explanation(scope = "budget_summary")
          return unless current_order
          i18n_scope = "decidim.lausanne.budgets.projects.#{scope}"
          if current_order.projects_rule?
            if current_order.minimum_projects.positive? && current_order.minimum_projects.to_i < current_order.maximum_projects.to_i
              t(
                "#{i18n_scope}.projects_rule.instruction",
                minimum_number: current_order.minimum_projects,
                maximum_number: current_order.maximum_projects
              )
            else
              t(
                "#{i18n_scope}.projects_rule_maximum_only.instruction",
                maximum_number: current_order.maximum_projects,
              )
            end
          elsif current_order.minimum_projects_rule?
            t(
              "#{i18n_scope}.minimum_projects_rule.instruction",
              minimum_number: current_order.minimum_projects.to_i,
              count: [current_order.minimum_projects - current_order.total_projects, 0].max
            )
          else
            t(
              "#{i18n_scope}.vote_threshold_percent_rule.instruction",
              minimum_budget: budget_to_currency(current_order.minimum_budget.to_i),
            )
          end
        end

        def current_rule_description
          return unless current_order
          if current_order.projects_rule?
            if current_order.minimum_projects.positive? && current_order.minimum_projects.to_i < current_order.maximum_projects.to_i
              t(
                ".projects_rule.description",
                minimum_number: current_order.minimum_projects,
                maximum_number: current_order.maximum_projects,
                scope: "decidim.lausanne.budgets.projects.budget_summary"
              )
            else
              t(
                ".projects_rule_maximum_only.description",
                maximum_number: current_order.maximum_projects.to_i,
                scope: "decidim.lausanne.budgets.projects.budget_summary"
            )
            end
          elsif current_order.minimum_projects_rule?
            t(".minimum_projects_rule.description", minimum_number: current_order.minimum_projects, count: current_order.minimum_projects - current_order.total_projects)
          else
            t(".vote_threshold_percent_rule.description", minimum_budget: budget_to_currency(current_order.minimum_budget.to_i))
          end
        end
      end
    end
  end
end
