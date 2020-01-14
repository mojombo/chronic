$:.unshift File.expand_path('../lib', __FILE__)
require 'chronic/version'

Gem::Specification.new do |s|
  s.name = 'chronic'
  s.version = Chronic::VERSION
  s.summary     = 'Natural language date/time parsing.'
  s.description = 'Chronic is a natural language date/time parser written in pure Ruby.'
  s.authors  = ['Tom Preston-Werner', 'Lee Jarvis']
  s.email    = ['tom@mojombo.com', 'ljjarvis@gmail.com']
  s.homepage = 'http://github.com/mojombo/chronic'
  s.license = 'MIT'
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md HISTORY.md LICENSE]
  s.files = `git ls-files`.split($/)
  s.test_files = `git ls-files -- test`.split($/)

  s.add_runtime_dependency 'numerizer', '~> 0.2'

  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'activesupport', '~> 4'
end
