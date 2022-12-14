# frozen_string_literal: true

class CreateLausanneLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_lausanne_budgets_line_items do |t|
      t.references :decidim_order, index: true
      t.references :decidim_project, index: true
    end

    add_index :decidim_lausanne_budgets_line_items, [:decidim_order_id, :decidim_project_id], unique: true, name: "decidim_lausanne_budgets_line_items_order_project_unique"
  end
end
