# frozen_string_literal: true

require_relative "lib/request/history/version"

Gem::Specification.new do |spec|
  spec.name = "request-history"
  spec.version = Request::History::VERSION
  spec.authors = ["Marcelo Ribeiro"]
  spec.email = ["marcelorxs@gmail.com"]

  spec.summary = "Request history record pattern for Rails applications."
  spec.homepage = "https://github.com/marcelorxaviers/request-history"
  spec.licenses      = %w(Nonstandard)

  spec.required_ruby_version = ">= 3.1.2"

  if spec.respond_to?(:metadata)
    spec.metadata["changelog_uri"] = "https://github.com/marcelorxaviers/request-history/blob/master/CHANGELOG.md"
    spec.metadata["source_code_uri"] = "https://github.com/marcelorxaviers/request-history"
    spec.metadata["documentation_uri"] = "https://github.com/marcelorxaviers/request-history/blob/master/README.md"
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.2"
  spec.add_dependency "sidekiq", ">= 6.5.4", "< 7"

  spec.add_development_dependency "mocha", "~> 1.14"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rails", "~> 7.0.4", ">= 7.0.4.2"
  spec.add_development_dependency "rake", ">= 13.0.6"
  spec.metadata["rubygems_mfa_required"] = "true"
end
