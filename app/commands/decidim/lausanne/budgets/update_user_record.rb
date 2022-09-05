# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      class UpdateUserRecord < Rectify::Command
        attr_reader :user_record, :budget, :current_user
        def initialize(user_record, budget, current_user)
          @user_record = user_record
          @budget = budget
          @current_user = current_user
        end

        def call
          return broadcast(:invalid) unless budget
          return broadcast(:invalid) if user_record.invalid?

          new_user_record = nil
          transaction do
            new_user_record = UserRecord.create(
              first_name: user_record.first_name,
              last_name: user_record.last_name,
              birthdate: user_record.birthdate,
              iam_lausanne: user_record.iam_lausanne,
              its_me: user_record.its_me,
              allow_process_data: user_record.allow_process_data,
              user: current_user || nil,
              order: Order.create(
                budget: budget
              )
            )
          rescue e
            broadcast(:invalid)
          end
          broadcast(:ok, new_user_record)
        end
      end
    end
  end
end
