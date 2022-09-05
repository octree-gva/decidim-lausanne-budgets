# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # The data store for a personal record submitted to
      # start a vote order.
      class UserRecord < ApplicationRecord
        include Traceable
        self.table_name = :decidim_lausanne_user_records
        belongs_to :user,
          class_name: "Decidim::User",
          foreign_key: "decidim_user_id",
          optional: true
        has_one :order,
          class_name: "Decidim::Lausanne::Budgets::Order",
          foreign_key: "loz_user_record_id"
        has_one :budget, through: :order, foreign_key: "loz_budgets_budget_id"

        def unique_submission?
        end
        def has_budget?
          !!budget
        end
      end
    end
  end
end
