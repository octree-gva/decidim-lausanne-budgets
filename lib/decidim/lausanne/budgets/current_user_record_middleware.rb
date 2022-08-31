module Decidim
  module Lausanne
    module Budgets
      class CurrentUserRecordMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          request = ActionDispatch::Request.new(env)
          env["decidim_current_user_record"] = request.cookie_jar.encrypted["decidim_current_user_record"].to_i || nil
          @app.call(env)
        end
      end
    end
  end
end
