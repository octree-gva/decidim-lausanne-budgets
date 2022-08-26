# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
ENV["NODE_ENV"] ||= "test"
ENV["ENGINE_ROOT"] = File.dirname(__dir__)
require "decidim/dev"
Decidim::Dev.dummy_app_path = File.expand_path(File.join(__dir__, "dummy"))

require "decidim/dev/test/base_spec_helper"
require "decidim/core/test/factories"


require "decidim/dev/test/base_spec_helper"
