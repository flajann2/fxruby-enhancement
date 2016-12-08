# encoding: utf-8

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'semver'

def s_version
  SemVer.find.format "%M.%m.%p%s"
end

require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "fxruby-enhancement"
  gem.homepage = "http://github.com/flajann2/fxruby-enhancement"
  gem.license = "MIT"
  gem.summary = %Q{fxruby enhancements}
  gem.description = %Q{The fxruby library is an excellent wrapper for the FOX toolkit. However, it reflects the
  C++-ness of FOX, rather than being more Ruby-like. As such, creating composed objects with
  it tends to be rather ugly and cumbersome.

  fxruby-enhancement is a wrapper for the wrapper, to "rubyfy" it and make it more easy to 
  use for Rubyists. 

  fxruby-enhancement is basically a DSL of sorts, and every effort has been taken to make 
  it intuitive to use. Once you get the hang of it, you should be able to look at the FXRuby
  API documentation and infer the DSL construct for fxruby-enhancement.}
  
  gem.email = "fred.mitchell@gmx.de"
  gem.authors = ["Fred Mitchell"]
  gem.version = s_version
  gem.required_ruby_version = '>= 2.3.1'

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

desc "Convert rdoc-sources to a static introspection for DSL."
task :scrape do
  ruby "build/scrape-rdoc.rb"
end

require 'yard'
YARD::Rake::YardocTask.new
