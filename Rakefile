# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/chronic.rb'

Hoe.new('chronic', Chronic::VERSION) do |p|
  p.rubyforge_name = 'chronic'
  p.summary = 'A natural language date parser'
  p.author = 'Tom Preston-Werner'
  p.email = 'tom@rubyisawesome.com'
  p.description = p.paragraphs_of('README.txt', 2).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.need_tar = false
  p.extra_deps = []
end

# vim: syntax=Ruby