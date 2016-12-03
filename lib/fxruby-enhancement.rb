require 'fox16'
require 'ostruct'
require 'awesome_print'

class String
  def snake
    self.gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase
  end
end

class Symbol
  def snake
    self.to_s.snake.to_sym
  end
end

require_relative 'fxruby-enhancement/enhancement'
require_relative 'fxruby-enhancement/ostruct-monkey'
require_relative 'fxruby-enhancement/api-mapper'
