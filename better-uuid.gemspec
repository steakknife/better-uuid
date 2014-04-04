$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'better-uuid/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'better-uuid'
  s.version     = BetterUUID::VERSION
  s.authors     = ['Barry Allard']
  s.email       = ['barry.allard@gmail.com']
  s.homepage    = 'https://github.com/steakknife/better-uuid'
  s.summary     = 'UUID library'
  s.description = 'Sensible UUID library as a gem'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*', '.rspec']
  s.require_path = 'lib'

  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rspec', '~> 0'
  s.add_development_dependency 'should_not', '~> 0'
  s.add_development_dependency 'absolute_time', '~> 0' unless RUBY_PLATFORM == 'java'
end
.tap {|gem| pk = File.expand_path(File.join('~/.keys', 'gem-private_key.pem')); gem.signing_key = pk if File.exist? pk; gem.cert_chain = ['gem-public_cert.pem']} # pressed firmly by waxseal
