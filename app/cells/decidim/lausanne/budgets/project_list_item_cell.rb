# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # This cell renders a horizontal project card
      # for an given instance of a Project in a budget list
      class ProjectListItemCell < Decidim::ViewModel
        include ActiveSupport::NumberHelper
        include Decidim::LayoutHelper
        include Decidim::ActionAuthorizationHelper
        include Decidim::Lausanne::Budgets::ProjectsHelper
        include Decidim::Lausanne::Budgets::Engine.routes.url_helpers

        delegate :current_user, :current_settings, :current_order, :current_user_record,  :current_component,
                 :current_participatory_space, :can_have_order?, :voting_open?, :voting_finished?,
                 :user_record_for_budget?, :voted_for?, :user_record_submitted?, to: :parent_controller

        private

          def resource_path
            resource_locator([model.budget, model]).path(filter_link_params)
          end

          def resource_title
            translated_attribute model.title
          end
          def resource_excerpt
            translated_attribute model.excerpt
          end

          def resource_added?
            current_order && current_order.projects.include?(model)
          end

          def resource_allocation
            current_order.allocation_for(model)
          end

          def data_class
            [].tap do |list|
              list << "budget-list__data--added" if can_have_order? && resource_added?
              list << "show-for-medium" if voting_finished? || (current_order_checked_out? && !resource_added?)
            end.join(" ")
          end

          def vote_button_disabled?
            !can_have_order?
          end

          def vote_button_class
            return "disabled" unless user_record_submitted?
            return "success" if resource_added?
            "hollow"
          end

          def vote_button_method
            return :delete if resource_added?
            :post
          end

          def vote_button_label
            if resource_added?
              return t(
                "decidim.lausanne.budgets.projects.project.remove",
                resource_name: resource_title
              )
            end

            t("decidim.lausanne.budgets.projects.project.add", resource_name: resource_title)
          end
      end
    end
  end
end
