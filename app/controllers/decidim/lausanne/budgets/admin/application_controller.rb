# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      module Admin
        # This controller is the abstract class from which all other controllers of
        # this engine inherit.
        #
        # Note that it inherits from `Decidim::Components::BaseController`, which
        # override its layout and provide all kinds of useful methods.
        class ApplicationController < Decidim::Admin::Components::BaseController
          helper_method :budget, :projects, :project

          def budget
            @budget ||= LausanneBudget.where(component: current_component).includes(:projects).find_by(id: params[:lausanne_budget_id])
          end

          def projects
            return unless budget

            @projects ||= budget.projects
          end

          def project
            return unless projects

            @project ||= projects.find(params[:id])
          end
        end
      end
    end
  end
end
