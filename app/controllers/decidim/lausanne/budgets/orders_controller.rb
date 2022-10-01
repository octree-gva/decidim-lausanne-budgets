# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # Exposes the order resource so users can checkout it.
      class OrdersController < Decidim::Lausanne::Budgets::ApplicationController
        include NeedsCurrentOrder
        def show
          render layout: "lausanne_budgets/print"
        end

        def checkout
          enforce_permission_to :vote, :project, order: current_order, budget: budget, workflow: current_workflow

          Checkout.call(current_order) do
            on(:ok) do
              flash[:notice] = I18n.t("orders.checkout.success", scope: "decidim")
              redirect_to lausanne_budgets_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("orders.checkout.error", scope: "decidim")
              redirect_to lausanne_budgets_path
            end
          end
        end

        def destroy
          CancelOrder.call(current_order) do
            on(:ok) do
              flash[:notice] = I18n.t("orders.destroy.success", scope: "decidim")
              redirect_to redirect_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("orders.destroy.error", scope: "decidim")
              redirect_to redirect_path
            end
          end
        end

        private

          def budget
            @budget ||= current_user_record.budget
          end

          def redirect_path
            if params[:return_to] == "budget"
              lausanne_budget_path(budget)
            else
              lausanne_budgets_path
            end
          end
      end
    end
  end
end
