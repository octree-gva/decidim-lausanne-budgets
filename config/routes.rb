# frozen_string_literal: true

Decidim.register_global_engine(
  :lausanne_budgets,
  ::Decidim::Lausanne::Budgets::Engine,
  at: "/public_budgets"
)
