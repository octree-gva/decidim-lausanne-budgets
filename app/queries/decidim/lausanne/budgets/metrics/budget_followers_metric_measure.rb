# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      module Metrics
        # Searches for unique Users following the next objects
        #  - Budgets
        class BudgetFollowersMetricMeasure < Decidim::MetricMeasure
          def valid?
            super && @resource.is_a?(Decidim::Component)
          end

          def calculate
            budgets = Decidim::Lausanne::Budgets::LausanneBudget.where(component: @resource)
            projects = Decidim::Lausanne::Budgets::Project.where(budget: budgets)

            budgets_followers = Decidim::Follow.where(followable: projects).joins(:user)
                                               .where("decidim_follows.created_at <= ?", end_time)
            cumulative_users = budgets_followers.pluck(:loz_user_record_id)

            budgets_followers = budgets_followers.where("decidim_follows.created_at >= ?", start_time)
            quantity_users = budgets_followers.pluck(:loz_user_record_id)

            {
              cumulative_users: cumulative_users.uniq,
              quantity_users: quantity_users.uniq
            }
          end
        end
      end
    end
  end
end
