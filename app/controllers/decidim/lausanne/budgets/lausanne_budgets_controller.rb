# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # Exposes the budget resources so users can participate on them
      class LausanneBudgetsController < Decidim::Lausanne::Budgets::ApplicationController
        before_filter :set_cache_headers

        def index
          redirect_to lausanne_budget_projects_path(current_workflow.single) if current_workflow.single?
        end

        def show
          raise ActionController::RoutingError, "Not Found" unless budget
          redirect_to lausanne_budget_projects_path(budget)
        end

          
        private

          def set_cache_headers
            response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
            response.headers["Pragma"] = "no-cache"
            response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
          end
          def budget
            @budget ||= LausanneBudget.where(component: current_component).includes(:projects).find_by(id: params[:id])
          end
      end
    end
  end
end
