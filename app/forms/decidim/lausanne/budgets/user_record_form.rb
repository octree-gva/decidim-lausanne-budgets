module Decidim
  module Lausanne
    module Budgets
      class UserRecordForm < Decidim::Form
        include TranslatableAttributes
        include TranslationsHelper
        include Decidim::ApplicationHelper
        mimic :user_record
        attribute :first_name, String
        attribute :last_name, String
        attribute :birthdate, String
        attribute :allow_process_data, Boolean
        attribute :its_me, Boolean
        attribute :iam_lausanne, Boolean

        validates :first_name, presence: true
        validates :last_name, presence: true
        validates :birthdate, presence: true
        validates :allow_process_data, presence: true
        validates :its_me, presence: true
        validates :iam_lausanne, presence: true
        validate :budget_context
        validate :unique!

        def budget_context
          errors.add(:base, "Budget context should be passed to UserRecordForm") unless budget.present?
        end

        def budget
          context.budget
        end

        ##
        # Extract the first name, last name and
        # birthday, remove all non-alpha numeric
        # and compare it to the database.
        def unique?
          !copies.exists?
        end

        def unique!
          return if context.user
          errors.add(:base, "Vous avez déjà soumis votre vote") unless unique?
        end

        def copies
          Decidim::Lausanne::Budgets::UserRecord.joins(:order).where(
            "UPPER(last_name) = UPPER(?)",
            last_name
          ).where(
            "UPPER(first_name) = UPPER(?)",
            first_name
          ).where(
            birthdate: birthdate,
            decidim_lausanne_budgets_orders: { loz_budgets_budget_id: budget.id }
          )
        end
      end
    end
  end
end
