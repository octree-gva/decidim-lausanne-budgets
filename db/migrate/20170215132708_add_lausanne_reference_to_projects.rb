# frozen_string_literal: true

class AddLausanneReferenceToProjects < ActiveRecord::Migration[5.0]
  class Project < ApplicationRecord
    self.table_name = :loz_budgets_projects
  end

  def change
    add_column :loz_budgets_projects, :reference, :string
    Project.find_each(&:save)
    change_column_null :loz_budgets_projects, :reference, true
  end
end
