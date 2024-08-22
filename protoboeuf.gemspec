# frozen_string_literal: true

require_relative "lib/protoboeuf/version"

Gem::Specification.new do |spec|
  spec.name = "protoboeuf"
  spec.version = ProtoBoeuf::VERSION
  spec.authors = ["Shopify Engineering"]
  spec.email = ["gems@shopify.com"]

  spec.summary = "A pure-Ruby protobuf encoder / decoder supporting `proto3`"
  spec.description = "This Ruby gem is aimed at Shopify-internal use cases, and currently comes with limited support."
  spec.homepage = "https://github.com/Shopify/protoboeuf"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  spec.bindir = "exe"
  spec.executables = ["protoboeuf"]
  spec.require_paths = ["lib"]
  spec.files = Dir.glob(%w[lib/**/*.rb]) + %w[README.md Gemfile Rakefile]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.add_dependency("syntax_tree", "~> 6.2")

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 3.3"

  spec.license = "MIT"
end
