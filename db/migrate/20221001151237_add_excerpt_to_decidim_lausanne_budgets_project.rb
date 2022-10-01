class AddExcerptToDecidimLausanneBudgetsProject < ActiveRecord::Migration[5.2]
  def change
    change_table :loz_budgets_projects do |t|
      t.jsonb :excerpt
    end
  end
end
