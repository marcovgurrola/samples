#Define a method sum which takes an array of integers as an argument and #returns the sum of its elements. For an empty array it should return zero
def sum(nums)
  return 0 if nums.nil? || nums.length < 1
  result = 0
  nums.each do |num|
    return 0 if nums.nil? || !num.is_a?(Integer)
    result += num
  end
  result
end

=begin
Define a method max_2_sum which takes an array of integers as an argument and returns the sum of its two largest elements. For an empty array it should return zero. For an array with just one element, it should return that element.
=end
def max_2_sum(nums)
  return 0 if nums.nil?
  return nums[0] if nums.length == 1
  result = 0
  nums.sort! { |x, y| y <=> x }

  for i in 0..1
    return 0 if nums[i].nil? || !nums[i].is_a?(Integer)
    result += nums[i]
  end
  result
end

=begin
Define a method sum_to_n? which takes an array of integers and an additional integer, n, as arguments and returns true if any two distinct elements in the array of integers sum to n. An empty array or single element array should both return false.
=end
def sum_to_n?(a, num)
  return false if a.nil? || a.length == 1 || num.nil? || !num.is_a?(Integer)

  for i in 0...a.length do
    return false if !a[i].is_a?(Integer)
	for j in 0...a.length do
	  return true if j != i and a[j] + a[i] == num
	end
  end
  false
end