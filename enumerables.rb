# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

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
    to_a.my_each { |val| arr << val if yield(val) }
    is_a?(Array) || is_a?(Range) ? arr : arr.to_h
  end

  def my_all?(para = nil)
    if !block_given? && !para
      to_a.my_each { |val| return false unless val }
    elsif para.is_a?(Class)
      to_a.my_each { |val| return false unless val.is_a?(para) }
    elsif para.is_a?(Regexp)
      to_a.my_each { |val| return false unless para.match(val) }
    elsif para
      to_a.my_each { |val| return false unless val == para }
    else
      to_a.my_each { |val| return false unless yield(val) }
    end
    true
  end

  def my_any?(para = nil)
    if !block_given? && !para
      to_a.my_each { |val| return true if val }
    elsif para.is_a?(Class)
      to_a.my_each { |val| return true if val.is_a?(para) }
    elsif para.is_a?(Regexp)
      to_a.my_each { |val| return true if para.match(val) }
    elsif para
      to_a.my_each { |val| return true if val == para }
    else
      to_a.my_each { |val| return true if yield(val) }
    end
    false
  end

  def my_none?(para = nil)
    if !block_given? && !para
      to_a.my_each { |val| return false if val }
    elsif para.is_a?(Regexp)
      to_a.my_each { |val| return false if para.match(val) }
    elsif para.is_a?(Class)
      to_a.my_each { |val| return false if val.is_a?(para) }
    elsif para
      to_a.my_each { |val| return false if val == para }
    else to_a.my_each { |val| return false if yield(val) }
    end
    true
  end

  def my_count(para = nil)
    counter = 0
    if block_given?
      to_a.my_each { |val| counter += 1 if yield(val) }
    elsif para
      to_a.my_each { |val| counter += 1 if para == val }
    else counter = to_a.length
    end
    counter
  end

  def my_map(my_proc = nil)
    return to_enum(:my_map) unless block_given? || my_proc

    arr = []
    if my_proc
      to_a.my_each { |val| arr << my_proc.call(val) }
    else to_a.my_each { |val| arr << yield(val) }
    end
    arr
  end

  def my_inject(initial_1 = nil, initial_2 = nil)
    if initial_1.is_a?(Symbol) && !initial_2
      memo = to_a[0]
      1.upto(to_a.length - 1) { |i| memo = memo.send(initial_1, to_a[i]) }
    elsif !initial_1.is_a?(Symbol) && initial_2.is_a?(Symbol)
      memo = initial_1
      0.upto(to_a.length - 1) { |i| memo = memo.send(initial_2, to_a[i]) }
    elsif block_given? && initial_1
      memo = initial_1
      to_a.my_each { |val| memo = yield(memo, val) }
    elsif block_given? && !initial_1
      memo = to_a[0]
      1.upto(to_a.length - 1) { |i| memo = yield(memo, to_a[i]) }
    elsif !block_given? && !initial_1
      raise LocalJumpError
    else return 'input error'
    end
    memo
  end
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

def multiply_els(arr)
  arr.my_inject(:*)
end
