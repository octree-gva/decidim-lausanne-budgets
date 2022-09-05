# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # A command with all the business to cancel an order.
      class CancelOrder < Rectify::Command
        # Public: Initializes the command.
        #
        # order - The current order for the user.
        def initialize(order)
          @order = order
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        #
        # Returns nothing.
        def call
          transaction do
            cancel_order!
          end
          broadcast(:ok, @order)
        end

        private
          def user_record
            @order.user_record
          end
          # If the order is not linked to a user, 
          # remove the user_record and the order.
          # If the order is linked to a user, remove all the votes
          def cancel_order!
            @order.line_items.each do |line|
              line.destroy!
            end
            unless user_record.user
              @order.user_record.destroy!
            end
            @order.update(checked_out_at: nil)
          end
      end
    end
  end
end
