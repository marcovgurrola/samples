module FunWithStrings
  def palindrome?
    cleared_self = self.gsub(/(\W|\d)/, '').downcase
    cleared_self == cleared_self.reverse ? true : false
  end
  def count_words
    cleared_array = self.downcase.gsub(/(\W|\d|\\n|\\t)/, ' ').split
    h = Hash.new(0)
    cleared_array.each { |word| h[word] += 1 } ; h
  end
  def anagram_groups
    self.split.group_by { |word| word.chars.sort }.values
  end
end

# make all the above functions available as instance methods on Strings:

class String
  include FunWithStrings
end