
# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_lausanne_personal_records do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :birthdate, null: false
      t.references :decidim_user, index: false, null: true
      t.timestamps
    end
  end
end
