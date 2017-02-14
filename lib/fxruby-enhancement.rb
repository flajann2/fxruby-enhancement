require 'fox16'
require 'fox16/colors'
require 'ostruct'
require 'awesome_print'
require 'forwardable'
require 'queue_ding'
require 'rgb'
require 'tickmarks'

include QueueDing
include Tickmarks

require_relative 'fxruby-enhancement/rgb-monkey'
require_relative 'fxruby-enhancement/color-mapper'
require_relative 'fxruby-enhancement/core-monkey'
require_relative 'fxruby-enhancement/enhancement'
require_relative 'fxruby-enhancement/ostruct-monkey'
require_relative 'fxruby-enhancement/api-mapper'
require_relative 'fxruby-enhancement/xtras'
