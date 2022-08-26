# frozen_string_literal: true

class AddLausanneBudgetReferenceToProject < ActiveRecord::Migration[5.2]
  def change
    add_reference :loz_budgets_projects, :loz_budgets_budget, foreign_key: true
  end
end
