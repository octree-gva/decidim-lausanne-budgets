module Decidim
  module Lausanne
    module Budgets
      class UserRecordsController < ApplicationController
        before_action :budget
        def create
          form = UserRecordForm.from_params(
            params.require(:user_record)
          ).with_context(budget: budget)
          respond_to do |format|
            CreateUserRecord.call(form, budget, current_user) do
              on(:ok) do |user_record|
                stick_user_record(user_record.id)
                format.html { redirect_back(fallback_location: lausanne_budget_path(budget)) }
              end
              on(:invalid) do
                format.html { redirect_back(fallback_location: lausanne_budget_path(budget)) }
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

          def stick_user_record(user_record_id)
            request.cookie_jar.encrypted["decidim_current_user_record"] = "#{user_record_id}" unless user_record_id.nil?
          end
      end
    end
  end
end
