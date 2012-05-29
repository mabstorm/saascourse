#!/usr/local/bin/ruby 
# -*- coding: utf-8 -*-

require 'pp'

# used to learn out non-alphabetical characters
def clean_string(string)
  return string.downcase.gsub(/[^a-z0-9]/, '')
end

# determine if some item is a palindrome, returns bool
def palindrome?(item)
  item_ar = [*item].map {|str| str.class==String ? clean_string(str) : str}
  item_ar = item_ar[0] if (item.class==String)
  return (item_ar==item_ar.reverse)
end

# now should work for "foo".palindrome? and palindrome?("foo")
class String
  def method_missing(method_id, *arguments)
    (method_id==:palindrome?) ? palindrome?(self) : super
  end
end

# make palindrome?() work for all enumerables
module Enumerable
  def method_missing(method_id, *arguments)
    return palindrome?(self) if (method_id==:palindrome?)
  end
end

class Class
  def attr_accessor_with_history(attr_name)
    attr_name = attr_name.to_s # make sure it's a string
    attr_reader attr_name # create the attribute's getter
    attr_reader attr_name+"_history" # create bar_history getter
    class_eval(%Q[
        def #{attr_name}=(val)
          @#{attr_name}=val
          if (@#{attr_name+"_history"}.nil?)
            @#{attr_name+"_history"} = [nil]
          end
          @#{attr_name+"_history"}.push(val)
        end
              ])
        
  end
end

class Numeric
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1.0}
  def method_missing(method_id, *arguments)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      super
    end
  end
  def in(currency)
    singular_currency = currency.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self / @@currencies[singular_currency]
    else
      raise UnknownCurrencyError
    end
  end
end

class UnknownCurrencyError < StandardError ; end
class Foo; attr_accessor_with_history :bar; end
class SomeOtherClass
  attr_accessor_with_history :foo
  attr_accessor_with_history :bar
end
# testing main
if __FILE__ == $0
  f = Foo.new
  f.bar = 1
  f.bar = 2
  if (f.bar_history!=[nil,1,2])
    puts "failed: #{f.bar_history} should be [nil,1,2]"
  else
    puts "passed initial"
  end
  f = Foo.new
  f.bar = 3
  f.bar = 4
  if (f.bar_history!=[nil,3,4])
    puts "failed: #{f.bar_history} should be [nil,3,4]"
  else
    puts "passed reset"
  end
  
  soc = SomeOtherClass.new
  soc.foo = 6
  soc.bar = 8
  soc.foo = 7
  soc.bar = 9

  if (f.bar_history!=[nil,3,4])
    puts "failed: #{f.bar_history} should be [nil,3,4]"
  else
    puts "passed other class non-interference"
  end
  if (soc.foo_history!=[nil,6,7] || soc.bar_history!=[nil,8,9])
    puts "failed: #{soc.foo_history}!=[nil,6,7] ||\
#{soc.bar_history}!=[nil,8,9]"
  else
    puts "passed new class stuff"
  end
  
  # palindrome? testing
  test_strings = {"A man, a plan, a canal -- Panama"=>true,
                  "Madam, I'm Adam!"=>true,
                  "Abracadabra"=>false,
                  "ala"=>true,
                  [1,2,3]=>false,
                  [1,2,2,1]=>true,
                  {21=>false}=>true,
                  ["water",21,22,21,"WATER"]=>true,
                  ["water",58,"fire"]=>false
                }
  test_strings.each_pair do |string, answer|
    PP.pp string
    if (palindrome?(string)==answer && string.palindrome?()==answer) 
      puts "right: #{answer}"
    else 
      puts "wrong: should not be #{answer}"
    end
  end 

end
