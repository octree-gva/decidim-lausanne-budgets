# frozen_string_literal: true

class AddLausanneScopeToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_reference :loz_budgets_budgets, :decidim_scope, foreign_key: true, index: true
  end
end
