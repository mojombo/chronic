require 'rubygems'

SPEC = Gem::Specification.new do |s|
  s.name = 'chronic'
  s.version = '0.3.0'
  s.author = 'Tom Preston-Werner'
  s.email = 'tom@rubyisawesome.com'
  s.homepage = 'http://chronic.rubyforge.org'
  s.platform = Gem::Platform::RUBY
  s.summary = "A natural language date parser"
  candidates = Dir["{lib,test}/**/*"]
  s.files = candidates.delete_if do |item|
    item.include?('.svn')
  end
  s.require_path = "lib"
  s.autorequire = "chronic"
  s.test_file = "test/suite.rb"
  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
  s.rdoc_options << '--main' << 'README'
end