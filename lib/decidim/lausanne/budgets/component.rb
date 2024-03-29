# frozen_string_literal: true

require "decidim/components/namer"

Decidim.register_component(:lausanne_budgets) do |component|
  component.engine = Decidim::Lausanne::Budgets::Engine
  component.admin_engine = Decidim::Lausanne::Budgets::AdminEngine
  component.icon = "decidim/lausanne/budgets/icon.svg"
  component.stylesheet = "decidim/lausanne/budgets/budgets"
  component.permissions_class_name = "Decidim::Lausanne::Budgets::Permissions"
  component.component_form_class_name = "Decidim::Lausanne::Budgets::Admin::ComponentForm"
  component.data_portable_entities = ["Decidim::Lausanne::Budgets::Order"]
  component.newsletter_participant_entities = ["Decidim::Lausanne::Budgets::Order"]
  # component.query_type = "Decidim::Lausanne::Budgets::LausanneBudgetsType"
  component.actions = %(vote)

  component.on(:before_destroy) do |instance|
    raise StandardError, "Can't remove this component" if Decidim::Lausanne::Budgets::LausanneBudget.where(component: instance).any?
  end

  component.register_resource(:budget) do |resource|
    resource.model_class_name = "Decidim::Lausanne::Budgets::LausanneBudget"
    resource.card = "decidim/lausanne/budgets/budget"
    resource.searchable = true
  end

  component.register_resource(:project) do |resource|
    resource.model_class_name = "Decidim::Lausanne::Budgets::Project"
    resource.template = "decidim/lausanne/budgets/projects/linked_projects"
    resource.card = "decidim/lausanne/budgets/project"
    resource.actions = %(vote)
    resource.searchable = true
  end

  component.register_stat :budgets_count, primary: true, priority: Decidim::StatsRegistry::LOW_PRIORITY do |components|
    Decidim::Lausanne::Budgets::LausanneBudget.where(component: components).count
  end

  component.register_stat :projects_count, priority: Decidim::StatsRegistry::LOW_PRIORITY do |components, start_at, end_at|
    Decidim::Lausanne::Budgets::FilteredProjects.for(components, start_at, end_at).count
  end

  component.register_stat :orders_count do |components, start_at, end_at|
    budgets = Decidim::Lausanne::Budgets::LausanneBudget.where(component: components)
    orders = Decidim::Lausanne::Budgets::Order.where(component: budgets)
    orders = orders.where("created_at >= ?", start_at) if start_at.present?
    orders = orders.where("created_at <= ?", end_at) if end_at.present?
    orders.count
  end

  component.register_stat :comments_count, tag: :comments do |components, start_at, end_at|
    projects = Decidim::Lausanne::Budgets::FilteredProjects.for(components, start_at, end_at)
    projects.sum(:comments_count)
  end

  component.register_stat :followers_count, tag: :followers, priority: Decidim::StatsRegistry::LOW_PRIORITY do |components, start_at, end_at|
    projects_ids = Decidim::Lausanne::Budgets::FilteredProjects.for(components, start_at, end_at).pluck(:id)
    Decidim::Follow.where(decidim_followable_type: "Decidim::Lausanne::Budgets::Project", decidim_followable_id: projects_ids).count
  end

  component.exports :projects do |exports|
    exports.collection do |component_instance, _user, resource_id|
      budgets = resource_id ? Decidim::Lausanne::Budgets::LausanneBudget.find(resource_id) : Decidim::Lausanne::Budgets::LausanneBudget.where(decidim_component_id: component_instance)
      Decidim::Lausanne::Budgets::Project
        .where(loz_budgets_budget_id: budgets)
        .includes(:category, :component)
    end

    exports.include_in_open_data = true

    exports.serializer Decidim::Lausanne::Budgets::ProjectSerializer
  end

  component.settings(:global) do |settings|
    settings.attribute :scopes_enabled, type: :boolean, default: false
    settings.attribute :scope_id, type: :scope
    settings.attribute :workflow, type: :enum, default: "one", choices: -> { Decidim::Lausanne::Budgets.workflows.keys.map(&:to_s) }
    settings.attribute :projects_per_page, type: :integer, default: 12
    settings.attribute :vote_rule_threshold_percent_enabled, type: :boolean, default: true
    settings.attribute :vote_threshold_percent, type: :integer, default: 70
    settings.attribute :vote_threshold_percent, type: :integer, default: 70
    settings.attribute :vote_rule_minimum_budget_projects_enabled, type: :boolean, default: false
    settings.attribute :vote_minimum_budget_projects_number, type: :integer, default: 1
    settings.attribute :vote_rule_selected_projects_enabled, type: :boolean, default: false
    settings.attribute :vote_selected_projects_minimum, type: :integer, default: 0
    settings.attribute :vote_selected_projects_maximum, type: :integer, default: 1
    settings.attribute :comments_enabled, type: :boolean, default: true
    settings.attribute :comments_max_length, type: :integer, required: false
    settings.attribute :resources_permissions_enabled, type: :boolean, default: true
    settings.attribute :announcement, type: :text, translated: true, editor: true

    settings.attribute :landing_page_content, type: :text, translated: true, editor: true
    settings.attribute :more_information_modal, type: :text, translated: true
  end

  component.settings(:step) do |settings|
    settings.attribute :comments_blocked, type: :boolean, default: false
    settings.attribute :votes, type: :enum, default: "enabled", choices: %w(disabled enabled finished)
    settings.attribute :show_votes, type: :boolean, default: false
    settings.attribute :announcement, type: :text, translated: true, editor: true

    settings.attribute :landing_page_content, type: :text, translated: true, editor: true
    settings.attribute :more_information_modal, type: :text, translated: true
    settings.attribute :announcement, type: :text, translated: true, editor: true
  end

  component.seeds do |participatory_space|
    landing_page_content = Decidim::Faker::Localized.localized do
      "<h2>#{::Faker::Lorem.sentence}</h2>" \
        "<p>#{::Faker::Lorem.paragraph}</p>" \
        "<p>#{::Faker::Lorem.paragraph}</p>"
    end

    component = Decidim::Component.create!(
      name: Decidim::Components::Namer.new(participatory_space.organization.available_locales, :budgets).i18n_name,
      manifest_name: :budgets,
      published_at: Time.current,
      participatory_space: participatory_space,
      settings: {
        landing_page_content: landing_page_content,
        more_information_modal: Decidim::Faker::Localized.paragraph(sentence_count: 4),
        workflow: %w(one random asc all).sample
      }
    )

    rand(1...3).times do
      Decidim::Lausanne::Budgets::LausanneBudget.create!(
        component: component,
        title: Decidim::Faker::Localized.sentence(word_count: 2),
        description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(sentence_count: 3)
        end,
        total_budget: Faker::Number.number(digits: 8)
      )
    end

    Decidim::Lausanne::Budgets::LausanneBudget.where(component: component).each do |budget|
      rand(2...4).times do
        project = Decidim::Lausanne::Budgets::Project.create!(
          budget: budget,
          scope: participatory_space.organization.scopes.sample,
          category: participatory_space.categories.sample,
          title: Decidim::Faker::Localized.sentence(word_count: 2),
          description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
            Decidim::Faker::Localized.paragraph(sentence_count: 3)
          end,
          budget_amount: Faker::Number.number(digits: 8)
        )

        attachment_collection = Decidim::AttachmentCollection.create!(
          name: Decidim::Faker::Localized.word,
          description: Decidim::Faker::Localized.sentence(word_count: 5),
          collection_for: project
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(word_count: 2),
          description: Decidim::Faker::Localized.sentence(word_count: 5),
          attachment_collection: attachment_collection,
          attached_to: project,
          file: File.new(File.join(__dir__, "seeds", "Exampledocument.pdf"))
        )
        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(word_count: 2),
          description: Decidim::Faker::Localized.sentence(word_count: 5),
          attached_to: project,
          file: File.new(File.join(__dir__, "seeds", "city.jpeg"))
        )
        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(word_count: 2),
          description: Decidim::Faker::Localized.sentence(word_count: 5),
          attached_to: project,
          file: File.new(File.join(__dir__, "seeds", "Exampledocument.pdf"))
        )
        Decidim::Comments::Seed.comments_for(project)
      end
    end
  end
end
