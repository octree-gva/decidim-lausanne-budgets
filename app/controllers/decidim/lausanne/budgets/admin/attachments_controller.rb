# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      module Admin
        # Controller that allows managing all the attachments for a participatory
        # process.
        #
        class AttachmentsController < Admin::ApplicationController
          include Decidim::Admin::Concerns::HasAttachments

          def after_destroy_path
            budget_projects_path(project.budget)
          end

          def attached_to
            project
          end

          def project
            @project ||= Decidim::Lausanne::Budgets::Project.find(params[:project_id])
          end
        end
      end
    end
  end
end
