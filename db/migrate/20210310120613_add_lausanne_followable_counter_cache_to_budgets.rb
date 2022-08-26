# frozen_string_literal: true

class AddLausanneFollowableCounterCacheToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :loz_budgets_projects, :follows_count, :integer, null: false, default: 0, index: true

    reversible do |dir|
      dir.up do
        Decidim::Lausanne::Budgets::Project.reset_column_information
        Decidim::Lausanne::Budgets::Project.find_each do |record|
          record.class.reset_counters(record.id, :follows)
        end
      end
    end
  end
end
