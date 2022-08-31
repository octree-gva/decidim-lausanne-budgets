# frozen_string_literal: true

module Decidim
  module Lausanne
    module Budgets
      class CreateUserRecord < Rectify::Command
        attr_reader :user_record, :budget, :current_user
        def initialize(user_record, budget, current_user)
          @user_record = user_record
          @budget = budget
          @current_user = current_user
        end

        def call
          return broadcast(:invalid) unless budget
          return broadcast(:invalid) if user_record.invalid?
          # unless user_record.unique?
          #   return broadcast(:ok, user_record.copies.first)
          # end

          new_user_record = nil
          transaction do
            new_user_record = UserRecord.create(
              first_name: user_record.first_name,
              last_name: user_record.last_name,
              birthdate: user_record.birthdate,
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
