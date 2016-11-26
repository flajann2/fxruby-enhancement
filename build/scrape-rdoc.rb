# coding: utf-8
=begin rdoc
= Scrape RDoc from FXRuby
We need to scrape that and convert it to a form
suitable for static introspection of the FXRuby
API, with the implied parameters and their defaults
for the many classes in FXRuby
=end
require "erb" 
require 'pp'

SOURCES = File.expand_path("../fxruby/rdoc-sources", File.dirname(__FILE__))
TARGET = File.expand_path("../lib/fxruby-enhancement/api-mapper.rb", File.dirname(__FILE__))
TEMPLATE = File.expand_path("api-mapper.rb.erb", File.dirname(TARGET))

last_class = nil
api = Dir.entries(SOURCES)                   
      .select{ |f| /^FX.*\.rb$/ =~ f  }
      .sort
      .map{ |f| File.expand_path(f, SOURCES) }
      .map{ |f| File.open(f, "r").readlines }
      .flatten
      .reject{ |s| /^\s*#/ =~ s }
      .map{ |s| s
            .split(/#|;/).first
            .split('def').last
            .strip }
      .select{ |s| /class|initialize(?!d)/ =~ s }
      .map{ |s| s.split(/ |\(/, 2) }
      .map{ |type, rest| [type.to_sym, rest] }
      .map{ |type, rest| case type
                         when :class
                           [type, rest.split(/\b*<\b*/)]
                         when :initialize
                           [type,
                            (rest.nil?) ? nil
                            : rest.chomp.split(',')
                              .map{ |s| s
                                    .strip
                                    .split('=')}]
                         else
                           raise "unknown type #{type} for #{rest}"
                         end }
      .map{ |type, inf| [type,
                         case type
                         when :class
                           inf.map{ |s| s.strip.to_sym}
                         when :initialize
                           inf.map{ |var, deft|
                             [var.to_sym, deft] }.to_h unless inf.nil?
                         end ]}
      .group_by{ |type, inf| case type
                             when :class
                               last_class = inf.first
                             when :initialize
                               last_class
                             end }
      .map{ |klass, details| [klass,
                              details.group_by{ |type, inf| type }]}
      .map{ |klass, details| [klass,
                              details.map{ |type, inf| case type
                                                      when :class
                                                        inf.last
                                                      when :initialize
                                                        [type, inf.map{ |t, h| h }]
                                                      end }.to_h
                             ]}
      .to_h

pp api
