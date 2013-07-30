$:.unshift File.expand_path('../lib', __FILE__)
require 'chronic'

Gem::Specification.new do |s|
  s.name = 'chronic'
  s.version = Chronic::VERSION
  s.rubyforge_project = 'chronic'
  s.summary     = 'Natural language date/time parsing.'
  s.description = 'Chronic is a natural language date/time parser written in pure Ruby.'
  s.authors  = ['Tom Preston-Werner', 'Lee Jarvis']
  s.email    = ['tom@mojombo.com', 'ljjarvis@gmail.com']
  s.homepage = 'http://github.com/mojombo/chronic'
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md HISTORY.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test`.split("\n")

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', '~> 5.0'
end
