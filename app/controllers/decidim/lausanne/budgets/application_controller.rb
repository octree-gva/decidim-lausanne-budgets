# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Components::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Components::BaseController
        helper_method :current_workflow, :voting_finished?, :voting_open?, :current_user_record

        def current_workflow
          @current_workflow ||= Decidim::Lausanne::Budgets.workflows[workflow_name].new(current_component, current_user)
        end

        def current_user_record
          return @current_user_record if @current_user_record.present?
          saved_user_record = (request.env["decidim_current_user_record"] || "0").to_i
          match = find_current_user_record(saved_user_record)
          if match
            request.cookie_jar.encrypted["decidim_current_user_record"] =
              request.env["decidim_current_user_record"] = match.id
            @current_user_record = match
          else
            # remove previos cookies
            request.cookie_jar.encrypted["decidim_current_user_record"] =
              request.env["decidim_current_user_record"] = nil
            @current_user_record = UserRecord.new(user: current_user)
          end
        end

        def voting_open?
          current_settings.votes == "enabled"
        end

        def voting_finished?
          current_settings.votes == "finished"
        end

        def show_votes_count?
          current_settings.show_votes?
        end

        private
          def set_cache_headers
            response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
            response.headers["Pragma"] = "no-cache"
            response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
          end
          def find_current_user_record(user_record_id)
            if current_user
              user_record = UserRecord.where(user: current_user).first
              return user_record if user_record
            end
            matches = UserRecord.where(id: user_record_id)
            match = matches.first
            return nil unless match
            return nil if match.user && !current_user
            if current_user && !match.user
              match.update(user: current_user)
              match.reload
            else
              # if match && match.order && match.order.checked_out?
              #   return nil
              # end
              match
            end
          end
          def workflow_name
            @workflow_name ||= current_component.settings.workflow.to_sym
          end
      end
    end
  end
end
