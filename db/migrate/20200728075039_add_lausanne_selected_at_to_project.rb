# frozen_string_literal: true

class AddLausanneSelectedAtToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :loz_budgets_projects, :selected_at, :date, index: true
  end
end
