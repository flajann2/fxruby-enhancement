=begin rdoc
= Scrape RDoc from FXRuby
We need to scrape that and convert it to a form
suitable for static introspection of the FXRuby
API, with the implied parameters and their defaults
for the many classes in FXRuby
=end
require "erb" 

SOURCES = File.expand_path("../fxruby/rdoc-sources", File.dirname(__FILE__))
TARGET = File.expand_path("../lib/fxruby-enhancement/api-mapper.rb", File.dirname(__FILE__))
TEMPLATE = File.expand_path("api-mapper.rb.erb", File.dirname(TARGET))

files = Dir.entries(SOURCES)
        .select{ |f| /^FX.*\.rb$/ =~ f  }
        .map{ |f| File.expand_path(f, SOURCES) }
puts files

