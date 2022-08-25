# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_lausanne_budgets_orders do |t|
      #t.references :decidim_user, index: true
      t.references :decidim_lausanne_personal_record, index: true
      t.references :decidim_component, index: true
      t.datetime :checked_out_at

      t.timestamps
    end

    add_index :decidim_lausanne_budgets_orders, [:decidim_lausanne_personal_record_id, :decidim_component_id], unique: true, name: "decidim_lausanne_budgets_order_personal_record_component_unique"
  end
end
