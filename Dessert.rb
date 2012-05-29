#!/usr/local/bin/ruby 
# -*- coding: utf-8 -*-

require 'pp'

class Dessert
  attr_accessor :name, :calories
  def initialize(name, calories)
    @name = name
    @calories = calories
  end
  def healthy?
    @calories < 200 ? true : false
  end
  def delicious?
    return true
  end
end

class JellyBean < Dessert
  attr_accessor :flavor
  def initialize(name, calories, flavor)
    @name = name
    @calories = calories
    @flavor = flavor
  end
  def delicious?
    @flavor.downcase=="black licorice" ? false : true
  end
end


# testing main
if __FILE__ == $0
  d1 = Dessert.new("cake", 300)
  d2 = Dessert.new("granola", 100)
  jb1 = JellyBean.new("jellybean", 50, "black licorice")
  jb2 = JellyBean.new("jellybean", 50, "cherry")
  [d1, d2, jb1, jb2].each do |dessert|
    puts "name: #{dessert.name} - delicious: #{dessert.delicious?} -\
    healthy: #{dessert.healthy?}"
  end

end
