# coding: utf-8
require 'forwardable'
require 'pp'

class A
  attr_accessor :rogue, :lamb
  def initialize
    @rogue = 100
    @lamb = [1,2]
  end
end

class B
  extend Forwardable
  
  attr_accessor :a
  def_delegators :@a, :rogue, :rogue=, :lamb

  def initialize
    @a = A.new
    puts "initial a -- rogue #{rogue}, lamb #{lamb} "
    rogue ( 5)
    rogue = rogue + 1
    rogue += 10
    puts "final del -- rogue #{rogue}, lamb #{lamb} "   
    puts "final a   -- rogue #{a.rogue}, lamb #{a.lamb} "   
  end
end

B.new

