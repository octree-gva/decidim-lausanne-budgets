# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      class SendOrderSummaryJob < ApplicationJob
        queue_as :default

        def perform(order)
          return if order&.user&.email.blank?

          OrderSummaryMailer.order_summary(order).deliver_now
        end
      end
    end
  end
end
