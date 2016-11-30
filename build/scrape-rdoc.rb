# coding: utf-8

=begin rdoc
= Scrape RDoc from FXRuby
We need to scrape that and convert it to a form
suitable for static introspection of the FXRuby
API, with the implied parameters and their defaults
for the many classes in FXRuby
=end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fxruby-enhancement'
require 'erb'
require 'pp'

SOURCES = File.expand_path("../fxruby/rdoc-sources", File.dirname(__FILE__))
TARGET = File.expand_path("../lib/fxruby-enhancement/api-mapper.rb", File.dirname(__FILE__))
TEMPLATE = File.expand_path("api-mapper.rb.erb", File.dirname(TARGET))

# Indeed we parse the rdoc-sources to glean the actual API
# for FXRuby, since live introspection of the actual API
# is underdeterimed, being a wrapper for the underlying C++
# library, which does things, unsurpringly, in a very C++
# way. And so, I fight evil with evil here. So let the evil
# begin. 

last_class = nil
API = Dir.entries(SOURCES)                   
      .select{ |f| /^FX.*\.rb$/ =~ f  }
      .sort
      .map{ |f| File.expand_path(f, SOURCES) }
      .map{ |f| File.open(f, "r").readlines }
      .flatten
      .reject{ |s| /^\s*#/ =~ s }
      .map{ |s| s
            .split(/#|;|\)/).first
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
                            : rest.split(',')
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

pp API

# Now that we have the entire FXRuby API description,
# we now rely on the template to flesh out and create
# the DSL. Total insanity that I would attempt to use
# metaprograming to autogeneate a DSL. No worries. I've
# done worse. :p I aplogize for the apperent "ugliness"
# in this approach, but desperate times call for desperate
# measures...
#
# NOTE WELL
#   Please bear in mind that in the API structure, you will
#   see both nil and "nil" listed as default parameters. The
#   nil indicates a required parameter, whereas "nil" indicates
#   a default value for a parameter. Perhaps I should've gone
#   through the extra step of slapping in :required for
#   the nil entries, but getting the logic above was tricky
#   enough, and only those maintaning THIS code will ever
#   need be concerned about the distinctions.

File.open(TEMPLATE, 'r') do |template|
  File.open(TARGET, 'w') do |target|
    @api = API
    target.write ERB.new(template.read).result(binding)
  end
end
