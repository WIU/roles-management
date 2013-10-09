# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rubycas-client"
  s.version = "2.3.10.rc1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Campbell", "Matt Zukowski", "Matt Walker", "Matt Campbell"]
  s.date = "2013-10-09"
  s.description = "Client library for the Central Authentication Service (CAS) protocol."
  s.email = ["matt@soupmatt.com"]
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.files = [".gitignore", ".rspec", ".simplecov", ".travis.yml", "Appraisals", "CHANGELOG.txt", "Gemfile", "Guardfile", "History.txt", "LICENSE.txt", "README.rdoc", "Rakefile", "TODO.md", "VERSION", "examples/rails/README", "examples/rails/app/controllers/advanced_example_controller.rb", "examples/rails/app/controllers/application.rb", "examples/rails/app/controllers/simple_example_controller.rb", "examples/rails/app/views/advanced_example/index.html.erb", "examples/rails/app/views/advanced_example/my_account.html.erb", "examples/rails/app/views/simple_example/index.html.erb", "examples/rails/config/boot.rb", "examples/rails/config/environment.rb", "examples/rails/config/environments/development.rb", "examples/rails/config/environments/production.rb", "examples/rails/config/environments/test.rb", "examples/rails/config/initializers/inflections.rb", "examples/rails/config/initializers/mime_types.rb", "examples/rails/config/initializers/new_rails_defaults.rb", "examples/rails/config/routes.rb", "examples/rails/log/development.log", "examples/rails/log/production.log", "examples/rails/log/server.log", "examples/rails/log/test.log", "examples/rails/script/about", "examples/rails/script/console", "examples/rails/script/server", "gemfiles/.gitignore", "gemfiles/rails23.gemfile", "gemfiles/rails30.gemfile", "gemfiles/rails31.gemfile", "gemfiles/rails32.gemfile", "lib/casclient.rb", "lib/casclient/client.rb", "lib/casclient/frameworks/rails/cas_proxy_callback_controller.rb", "lib/casclient/frameworks/rails/filter.rb", "lib/casclient/responses.rb", "lib/casclient/tickets.rb", "lib/casclient/tickets/storage.rb", "lib/casclient/tickets/storage/active_record_ticket_store.rb", "lib/rubycas-client.rb", "lib/rubycas-client/version.rb", "rails_generators/active_record_ticket_store/USAGE", "rails_generators/active_record_ticket_store/active_record_ticket_store_generator.rb", "rails_generators/active_record_ticket_store/templates/README", "rails_generators/active_record_ticket_store/templates/migration.rb", "rubycas-client.gemspec", "spec/.gitignore", "spec/casclient/client_spec.rb", "spec/casclient/frameworks/rails/filter_spec.rb", "spec/casclient/tickets/storage/active_record_ticket_store_spec.rb", "spec/casclient/tickets/storage_spec.rb", "spec/casclient/validation_response_spec.rb", "spec/database.yml", "spec/spec_helper.rb", "spec/support/action_controller_helpers.rb", "spec/support/active_record_helpers.rb", "spec/support/local_hash_ticket_store.rb", "spec/support/local_hash_ticket_store_spec.rb", "spec/support/shared_examples_for_ticket_stores.rb"]
  s.homepage = "https://github.com/rubycas/rubycas-client"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Client library for the Central Authentication Service (CAS) protocol."
  s.test_files = ["spec/.gitignore", "spec/casclient/client_spec.rb", "spec/casclient/frameworks/rails/filter_spec.rb", "spec/casclient/tickets/storage/active_record_ticket_store_spec.rb", "spec/casclient/tickets/storage_spec.rb", "spec/casclient/validation_response_spec.rb", "spec/database.yml", "spec/spec_helper.rb", "spec/support/action_controller_helpers.rb", "spec/support/active_record_helpers.rb", "spec/support/local_hash_ticket_store.rb", "spec/support/local_hash_ticket_store_spec.rb", "spec/support/shared_examples_for_ticket_stores.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, ["~> 0.9.1"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, ["~> 0.9.1"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, ["~> 0.9.1"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
