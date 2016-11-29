# coding: utf-8
require 'fox16'
require_relative 'fxruby-enhancement/enhancement'
require_relative 'fxruby-enhancement/api-mapper'

class String
  def to_snake
    self.gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase
  end
end
