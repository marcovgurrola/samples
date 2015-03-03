def hello(name)
  return "Not a valid argument" if !validate_string?(name)
  "Hello, #{name}"
end

def starts_with_consonant?(s)
  return false if !validate_string?(s)
    
  alphabet = ("a".."z").to_a
  vowels = ["a","e","i","o","u"]
  cons = (alphabet - vowels)
  cons.include?(s[0].downcase) ? true : false
end

def binary_multiple_of_4?(s)
  return false if !validate_string?(s)
    
  if s =~ /[^0-1]/
    return false
  else
    s.to_i(2) % 4 == 0 ? true : false
  end
end

def validate_string?(s)
  return false if s.nil? || !s.is_a?(String) || s.size < 1
  true
end