# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # Exposes the budget resources so users can participate on them
      class LausanneBudgetsController < Decidim::Lausanne::Budgets::ApplicationController
        before_action :set_cache_headers

        def index
          redirect_to lausanne_budget_projects_path(current_workflow.single) if current_workflow.single?
        end

        def show
          raise ActionController::RoutingError, "Not Found" unless budget
          redirect_to lausanne_budget_projects_path(budget)
        end

          
        private

    
          def budget
            @budget ||= LausanneBudget.where(component: current_component).includes(:projects).find_by(id: params[:id])
          end
      end
    end
  end
end
