module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    
    0.upto(to_a.length - 1) do |i|
      yield(to_a[i])
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    
    0.upto(to_a.length - 1) do |i|
      yield(to_a[i], i)
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    
    arr = []
    to_a.my_each { |val| arr << val if yield(val)}

    (is_a? Array)? arr : arr.to_h
  end

  def my_all?
    return true unless block_given?

    to_a.my_each { |val| return false unless yield(val)}
    true
  end

  def my_any?
    return true unless block_given?

    to_a.my_each { |val| return true if yield(val)}
    false
  end

  def my_none?
    return true unless block_given?

    to_a.my_each { |val| return false if yield(val)}
    true
  end

  def my_count?(para = false)
    counter = 0
    if block_given?
      to_a.my_each { |val| counter+=1 if yield(val) }
    elsif para
      to_a.my_each { |val| counter+=1 if para == val }  
    else
      counter = to_a.length
    end
    counter
  end

  def my_map
    return to_enum(:my_map) unless block_given?
    
    arr = []
    to_a.my_each { |val| arr << yield(val) }
    arr
  end

  def my_inject(initial_1 = false, initial_2 = false)
    if initial_1.is_a?(Symbol) && initial_2 == false
      memo = to_a[0]
      1.upto(to_a.length - 1 ) { |i| memo = memo.send(initial_1, to_a[i])} 
    elsif initial_1.is_a?(Integer) && initial_2.is_a?(Symbol)
      memo = initial_1
      0.upto(to_a.length - 1 ) { |i| memo = memo.send(initial_2, to_a[i])} 
    else
      if block_given? && initial_1
        memo = initial_1
        to_a.my_each { |val| memo = yield(memo, val)}
      elsif block_given? && !initial_1
        memo = to_a[0]
        1.upto(to_a.length - 1 ) { |i| memo = yield(memo, to_a[i])}
      else
        return "input error"
      end
    end
    memo
  end
end

names = ["Jane", "John", "Philip", "Emmmanuel", "John"]
hash_names = {:Jane => "1", :John => "2", "Philip" => "3", "Emmmanuel" => "4"}
numbers = [3, 4, 5, 1]

puts "------#my_each-----"
names.my_each { |name| puts "Hello #{name}"}
hash_names.my_each { |k,v| puts "#{k} is #{v}"}
puts "------#my_each_with_index-------"
names.my_each_with_index { |name, index| puts "#{name}'s index is #{index}"}
puts "------#my_select-------"
p names.my_select { |name| name == "Jane"}
p hash_names.my_select { |k, v| v === "2"}
puts "--------#my_all-------"
p names.my_all? { |name| name.length > 4 }
p hash_names.my_all? { |k, v| v.is_a? String }
puts "--------#my_any-------"
p names.my_any? { |name| name.length < 5 }
p hash_names.my_any? { |k, v| v.is_a? Array }
puts "--------#my_none-------"
p names.my_none? { |name| name.length < 1 }
p hash_names.my_none? { |k, v| v.is_a? String }
puts "--------#my_count------"
p names.my_count? { |name| name.length == 4}
p names.my_count?("John")
p names.my_count?
puts "---------#my_map------------"
p names.my_map { |name| name.upcase}
p numbers.my_map { |num| num ** 2 }
puts "---------#my_inject----------"
p numbers.my_inject { |sum, n| sum + n }
p numbers.my_inject(100) { |sum, n| sum + n }
longest = %w{ cat sheep bear }.inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest   
p numbers.my_inject(:+)
p numbers.my_inject(:*)
p numbers.my_inject(2, :+)
#incorrect arguments passed
p numbers.my_inject(:+, 2) #=> "input error"
# argument and block passed
p (5..10).my_inject(1) { |product, n| product * n } #=> 151200