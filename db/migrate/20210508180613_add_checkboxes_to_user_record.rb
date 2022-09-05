# frozen_string_literal: true

class AddCheckboxesToUserRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_lausanne_user_records, :allow_process_data, :boolean
    add_column :decidim_lausanne_user_records, :its_me, :boolean
    add_column :decidim_lausanne_user_records, :iam_lausanne, :boolean
  end
end
