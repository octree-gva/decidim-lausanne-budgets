# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      # The data store for a personal record submitted to 
      # start a vote order.
      class UserRecord < ApplicationRecord
        include Traceable
        # Reference to connected user, if the user is logged in.
        has_one :user, class_name: "Decidim::User", foreign_key: "decidim_user_id"
      end
    end
  end
end
