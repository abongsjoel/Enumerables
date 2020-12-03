module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    
  0.upto(to_a.length - 1) do |i|
    yield(to_a[i])
  end
    self
  end
end

names = ["Jane", "John", "Philip", "Emmmanuel"]

puts "------my_each-----"
names.my_each { |name| puts "Hello #{name}"}