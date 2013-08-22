require 'date'

def version
  contents = File.read File.expand_path('../lib/chronic.rb', __FILE__)
  contents[/VERSION = "([^"]+)"/, 1]
end

def do_test
  $:.unshift './test'
  Dir.glob('test/test_*.rb').each { |t| require File.basename(t) }
end

def open_command
  case RUBY_PLATFORM
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    'start'
  when /darwin|mac os/
    'open'
  else
    'xdg-open'
  end
end

task :test do
  do_test
end

desc "Generate SimpleCov test coverage and open in your browser"
task :coverage do
  require 'simplecov'
  FileUtils.rm_rf("./coverage")
  SimpleCov.command_name 'Unit Tests'
  SimpleCov.at_exit do
    SimpleCov.result.format!
    sh "#{open_command} #{SimpleCov.coverage_path}/index.html"
  end
  SimpleCov.start
  do_test
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -Ilib -rchronic"
end

desc "Release Chronic version #{version}"
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/chronic-#{version}.gem"
end

desc "Build a gem from the gemspec"
task :build do
  FileUtils.mkdir_p "pkg"
  sh "gem build chronic.gemspec"
  FileUtils.mv("./chronic-#{version}.gem", "pkg")
end

task :default => :test