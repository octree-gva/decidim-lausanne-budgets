# frozen_string_literal: true
module Decidim
  module Lausanne
    module Budgets
      # This class handles search and filtering of projects. Needs a
      # `current_component` param with a `Decidim::Component` in order to
      # find the projects.
      class ProjectSearch < ResourceSearch
        text_search_fields :title, :description, :excerpt

        # Public: Initializes the service.
        # component     - A Decidim::Component to get the projects from.
        def initialize(options = {})
          super(Project.all, options)
        end
        def search_search_text
          return query unless self.class.text_search_fields.any?
          fields = self.class.text_search_fields.dup
          text_query = query.where(localized_search_text_in("#{query.table_name}.#{fields.shift}"), text: "%#{search_text}%")
          fields.each do |field|
            text_query = text_query.or(query.where(localized_search_text_in("#{query.table_name}.#{field}"), text: "%#{search_text}%"))
          end
          text_query
        end
        # Creates the SearchLight base query.
        def base_query
          raise "Missing budget" unless budget
          raise "Missing component" unless component
          @scope.where(budget: budget)
        end
        # A search method.
        def search_title
          # If `"title"` was the first key in the options_hash,
          # `query` here will be the base query, namely, `Person.all`.
          query.where(title: options[:title])
        end

        # Another search method.
        def search_description
          # If `"description"` was the second key in the options_hash,
          # `query` here will be whatever `search_first_name` returned.
          query.where(description: description)
        end
        # Returns the random projects for the current page.
        def results
          Project.where(id: super.pluck(:id)).includes([:scope, :component, :attachments, :category])
        end

        def search_status
          return query if status.member?("all")

          apply_scopes(%w(selected not_selected), status)
        end

        private

          # Private: Since budget is not used by a search method we need
          # to define the method manually.
          def budget
            options[:budget]
          end
      end
    end
  end
end
