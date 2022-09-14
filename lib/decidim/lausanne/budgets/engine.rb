# frozen_string_literal: true

require "searchlight"
require "kaminari"

module Decidim
  module Lausanne
    module Budgets
      # This is the engine that runs on the public interface of `decidim-budgets`.
      # It mostly handles rendering the created projects associated to a participatory
      # process.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Lausanne::Budgets

        routes do

          resources :lausanne_budgets, only: [:index, :show] do
            resources :projects, only: [:index, :show]
            resources :user_records
            resource :order, only: [:destroy] do
              member do
                post :checkout
              end
              resource :line_item, only: [:create, :destroy]
            end
          end

          root to: "lausanne_budgets#index"
        end

        initializer "lausanne_budgets.middlewares" do |app|
          app.config.middleware.insert_before Decidim::CurrentOrganization, Decidim::Lausanne::Budgets::CurrentUserRecordMiddleware
        end

        initializer "lausanne_budgets.assets" do |app|
          app.config.assets.precompile += %w(decidim_lausanne_budgets_manifest.js)
        end

        initializer "lausanne_budgets.add_cells_view_paths" do
          Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Lausanne::Budgets::Engine.root}/app/cells")
          Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Lausanne::Budgets::Engine.root}/app/views") # for partials
        end

        initializer "lausanne_budgets.register_metrics" do
          Decidim.metrics_operation.register(:participants, :lausanne_budgets) do |metric_operation|
            metric_operation.manager_class = "Decidim::Lausanne::Budgets::Metrics::BudgetParticipantsMetricMeasure"
          end

          Decidim.metrics_operation.register(:followers, :lausanne_budgets) do |metric_operation|
            metric_operation.manager_class = "Decidim::Lausanne::Budgets::Metrics::BudgetFollowersMetricMeasure"
          end
        end
      end
    end
  end
end
