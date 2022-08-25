# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_lausanne_budgets_projects do |t|
      t.jsonb :title
      t.jsonb :description
      t.bigint :budget_amount, null: false
      t.references :decidim_component, index: true
      t.references :decidim_scope, index: true

      t.timestamps
    end
  end
end
