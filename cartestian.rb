#!/usr/local/bin/ruby 
# -*- coding: utf-8 -*-

require 'pp'

# a x b array combinations
class CartesianProduct
  include Enumerable

  def initialize(a,b)
    @a1 = a
    @a2 = b
  end
  def each
    @a1.each do |a|
      @a2.each do |b|
        yield [a,b]
      end
    end
  end
end


# main
if __FILE__ == $0
#Examples of use
  c = CartesianProduct.new([:a,:b], [4,5])
  c.each { |elt| puts elt.inspect }
# [:a, 4]
# [:a, 5]
# [:b, 4]
# [:b, 5]
  c = CartesianProduct.new([:a,:b], [])
  c.each { |elt| puts elt.inspect }
# (nothing printed since Cartesian product
# of anything with an empty collection is empty)
end
