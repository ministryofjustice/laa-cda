# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'laa/cda/version'

Gem::Specification.new do |spec|
  spec.name          = 'laa-cda'
  spec.version       = LAA::Cda::VERSION
  spec.authors       = ['Joe Haig', 'Ministry of Justice']
  spec.email         = ['joseph.haig@digital.justice.gov.uk']
  spec.summary       = 'Ruby client for the Legal Aid Agency Court Data Adaptor'
  spec.description   = 'Ruby client for the Ministry of Justices LAA Court Data Adaptor.'
  spec.homepage      = 'https://github.com/ministryofjustice/laa-cda'
  spec.license       = 'MIT'
  spec.extra_rdoc_files = ['LICENSE', 'README.md']

  spec.files = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.3.0'

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'oauth2', '~> 2.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
