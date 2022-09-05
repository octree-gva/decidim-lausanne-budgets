module Decidim
  module Lausanne
    module Budgets
      class UserRecordsController < Decidim::Lausanne::Budgets::ApplicationController
        include FilterResource
        include NeedsCurrentOrder
        include Decidim::Lausanne::Budgets::Orderable
        helper_method :projects, :budget

        def show
          @user_record_form = UserRecordForm.from_params(
            params.require(:user_record)
          ).with_context(budget: budget, user: current_user)
          render :edit
        end

        def create
          @user_record_form = UserRecordForm.from_params(
            params.require(:user_record)
          ).with_context(budget: budget, user: current_user)
          respond_to do |format|
            CreateUserRecord.call(@user_record_form, budget, current_user) do
              on(:ok) do |user_record|
                stick_user_record(user_record.id)
                format.html { redirect_back(fallback_location: lausanne_budget_path(budget)) }
              end
              on(:invalid) do
                format.html { render :edit }
              end
            end
          end
        end

        def update
          @user_record_form = UserRecordForm.from_params(
            params.require(:user_record)
          ).with_context(budget: budget, user: current_user)
          respond_to do |format|
            UpdateUserRecord.call(@user_record_form, budget, current_user) do
              on(:ok) do |user_record|
                stick_user_record(user_record.id)
                format.html { redirect_back(fallback_location: lausanne_budget_path(budget)) }
              end
              on(:invalid) do
                format.html { render :edit }
              end
            end
          end
        end

        def destroy
          request.cookie_jar.encrypted["decidim_current_user_record"] =
              request.env["decidim_current_user_record"] = nil
          respond_to do |format|
            format.html { redirect_back(fallback_location: lausanne_budget_path(budget)) }
          end
        end

        private
          def budget
            @budget ||= LausanneBudget.find(params.require(:lausanne_budget_id))
          end

          def projects
            return @projects if @projects
            @projects = search.results.page(params[:page]).per(current_component.settings.projects_per_page)
            @projects = reorder(@projects)
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
          def search_klass
            ProjectSearch
          end


          def stick_user_record(user_record_id)
            request.cookie_jar.encrypted["decidim_current_user_record"] = "#{user_record_id}" unless user_record_id.nil?
          end
      end
    end
  end
end
