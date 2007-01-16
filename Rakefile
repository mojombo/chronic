# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/chronic.rb'

Hoe.new('chronic', Chronic::VERSION) do |p|
  p.rubyforge_name = 'chronic'
  p.summary = 'A natural language date parser'
  p.description = p.paragraphs_of('README.txt', 2).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.need_tar = false
  p.extra_deps = []
end

# vim: syntax=Ruby

__END__

require 'rubygems'

SPEC = Gem::Specification.new do |s|
  s.name = 'chronic'
  s.version = '0.1.5'
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