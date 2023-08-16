# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # Exposes the project resource so users can view them
      class ProjectsController < Decidim::Lausanne::Budgets::ApplicationController
        include FilterResource
        include NeedsCurrentOrder
        include Decidim::TranslationsHelper
        include Decidim::Lausanne::Budgets::Orderable

        helper_method :projects, :project, :budget, :add_decidim_page_title

        def add_decidim_page_title(title)

        end
        
        def index
          set_cache_headers
          @decidim_page_title =  [translated_attribute(current_order.component.participatory_space.title).strip + ": Les votes sont ouverts!"]
          @user_record_form = UserRecordForm.from_model(current_user_record)
          raise ActionController::RoutingError, "Not Found" unless budget
        end
        
        def show
          @decidim_page_title = [project.translated_title.strip + ": Les votes sont ouverts!"]
          @user_record_form = UserRecordForm.from_model(current_user_record)
          raise ActionController::RoutingError, "Not Found" unless budget
          raise ActionController::RoutingError, "Not Found" unless project
        end

        private


          def budget
            @budget ||= LausanneBudget.where(component: current_component).includes(:projects).find_by(id: params[:lausanne_budget_id])
          end

          def projects
            return @projects if @projects

            @projects = search.results.page(params[:page]).per(current_component.settings.projects_per_page)
            @projects = reorder(@projects)
          end

          def project
            @project ||= Project.find_by(id: params[:id])
          end

          def search_klass
            ProjectSearch
          end

          def default_filter_params
            {
              search_text: "",
              status: default_filter_status_params,
              scope_id: default_filter_scope_params,
              category_id: default_filter_category_params
            }
          end

          def default_filter_status_params
            voting_finished? ? %w(selected) : %w(all)
          end

          def context_params
            { budget: budget, component: current_component, organization: current_organization }
          end
      end
    end
  end
end
