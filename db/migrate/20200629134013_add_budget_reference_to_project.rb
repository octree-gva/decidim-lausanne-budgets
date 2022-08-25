# frozen_string_literal: true

class AddBudgetReferenceToProject < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_lausanne_budgets_projects, :decidim_lausanne_budgets_budget, foreign_key: true
  end
end
