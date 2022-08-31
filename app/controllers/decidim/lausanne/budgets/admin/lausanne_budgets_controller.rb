# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      module Admin
        # This controller allows the create or update a budget.
        class LausanneBudgetsController < Admin::ApplicationController
          helper_method :budgets, :budget, :finished_orders, :pending_orders,
                        :users_with_pending_orders, :users_with_finished_orders

          def index; end

          def new
            enforce_permission_to :create, :budget
            @form = form(LausanneBudgetForm).instance
          end

          def create
            enforce_permission_to :create, :budget
            @form = form(LausanneBudgetForm).from_params(params, current_component: current_component)
            CreateBudget.call(@form) do
              on(:ok) do
                flash[:notice] = I18n.t("lausanne_budgets.create.success", scope: "decidim.lausanne_budgets.admin")
                redirect_to lausanne_budgets_path
              end
              on(:invalid) do
                flash.now[:alert] = I18n.t("lausanne_budgets.create.invalid", scope: "decidim.lausanne_budgets.admin")
                render action: "new"
              end
            end
          end

          def edit
            enforce_permission_to :update, :budget, budget: budget
            @form = form(LausanneBudgetForm).from_model(budget)
          end

          def update
            enforce_permission_to :update, :budget, budget: budget
            @form = form(LausanneBudgetForm).from_params(params, current_component: current_component)

            UpdateBudget.call(@form, budget) do
              on(:ok) do
                flash[:notice] = I18n.t("budgets.update.success", scope: "decidim.lausanne_budgets.admin")
                redirect_to lausanne_budgets_path
              end

              on(:invalid) do
                flash.now[:alert] = I18n.t("budgets.update.invalid", scope: "decidim.lausanne_budgets.admin")
                render action: "edit"
              end
            end
          end

          def destroy
            enforce_permission_to :delete, :budget, budget: budget

            DestroyBudget.call(budget, current_user) do
              on(:ok) do
                flash[:notice] = I18n.t("budgets.destroy.success", scope: "decidim.lausanne_budgets.admin")
              end

              on(:invalid) do
                flash.now[:alert] = I18n.t("budgets.destroy.invalid", scope: "decidim.lausanne_budgets.admin")
              end
            end

            redirect_to lausanne_budgets_path
          end

          private

            def budgets
              @budgets ||= LausanneBudget.where(component: current_component).order(weight: :asc)
            end

            def budget
              @budget ||= budgets.find_by(id: params[:id])
            end

            def orders
              @orders ||= Order.where(loz_budgets_budget_id: budgets)
            end

            def pending_orders
              orders.pending
            end

            def finished_orders
              orders.finished
            end

            def users_with_pending_orders
              orders.pending.pluck(:loz_user_record_id).uniq
            end

            def users_with_finished_orders
              orders.finished.pluck(:loz_user_record_id).uniq
            end
        end
      end
    end
  end
end
