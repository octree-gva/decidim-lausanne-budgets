# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # This cell renders information when current user can't create more budgets orders.
      class LimitAnnouncementCell < BaseCell
        alias budget model
        delegate :voted?, :vote_allowed?, :discardable, :limit_reached?, to: :current_workflow
        delegate :voting_open?, to: :controller

        def show
          cell("decidim/announcement", announcement_message, callout_class: "warning") if announce?
        end

        private

          def announce?
            return unless voting_open?
            return unless current_user
            return if vote_allowed?(budget)
            return if voted?(budget)

            discardable.any? || !vote_allowed?(budget, consider_progress: false)
          end

          def announcement_message
            if discardable.any?
              t(:limit_reached, scope: i18n_scope,
                                links: budgets_link_list(discardable),
                                landing_path: lausanne_budgets_path)
            else
              t(:cant_vote, scope: i18n_scope, landing_path: lausanne_budgets_path)
            end
          end

          def should_discard_to_vote?
            limit_reached? && discardable.any?
          end

          def i18n_scope
            "decidim.lausanne_budgets.limit_announcement"
          end
      end
    end
  end
end
