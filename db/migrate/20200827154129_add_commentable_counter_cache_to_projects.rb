# frozen_string_literal: true

class AddCommentableCounterCacheToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_lausanne_budgets_projects, :comments_count, :integer, null: false, default: 0, index: true
    Decidim::Lausanne::Budgets::Project.reset_column_information
    Decidim::Lausanne::Budgets::Project.find_each(&:update_comments_count)
  end
end
