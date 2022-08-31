# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Lausanne
    module Budgets
      # Shared behaviour for controllers that need the current order to be present.
      module NeedsCurrentOrder
        extend ActiveSupport::Concern

        included do
          helper_method :current_order, :can_have_order?, :voted_for?, :user_record_for_budget?,
          :user_record_submitted?

          def user_record_for_budget?
            return true if current_user_record.new_record?
            current_user_record.order.id == current_order.id
          end
          def user_record_submitted?
            !current_user_record.new_record?
          end

          def current_order
            @current_order ||= Order.includes(:projects).find_or_initialize_by(
              user_record: current_user_record,
              budget: budget
            )
          end

          def current_order=(order)
            @current_order = order
          end

          def persisted_current_order
            current_order if current_order&.persisted?
          end

          def can_have_order?
            voting_open? &&
            allowed_to?(:create, :order, budget: budget, workflow: current_workflow)
          end

          # Return true if the user has voted the project
          def voted_for?(project)
            current_order && current_order.projects.include?(project)
          end
        end
      end
    end
  end
end
