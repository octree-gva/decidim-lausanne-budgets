# frozen_string_literal: true

class AddBudgetReferenceToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_lausanne_budgets_orders, :decidim_lausanne_budgets_budget, foreign_key: true
  end
end
