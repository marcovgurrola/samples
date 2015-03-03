# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  index1 = page.body.index(e1)
  index2 = page.body.index(e2)
  index2 > index1 ? true : false
end

#When /^(?:|I )check "([^"]*)"$/ do |field|
When /I check the following ratings: (.*)/ do |rating_list|
  rating_list.split(%r{\s*,\s*}).each do |name, val|
    check("ratings[#{name}]")
  end
end

When /I uncheck the following ratings: (.*)/ do |rating_list|
  rating_list.split(%r{\s*,\s*}).each do |name, val|
    uncheck("ratings[#{name}]")
  end
end

# HINT: use String#split to split up the rating_list, then
# iterate over the ratings and reuse the "When I check..." or
#   "When I uncheck..." steps in lines 89-95 of web_steps.rb

Then /I should see all the movies/ do
  assert Movie.find(:all).length != page.body.scan(/<tr>/).length, "NOK"
end

Then /I should see the following ratings checked: (.*)/ do |rating_list|
  rating_list.split(%r{\s*,\s*}).each do |name, val|
    assert_equal(has_checked_field?("ratings_#{name}"), true, 'checkbox unchecked or nil')
  end
end

Then /I should not see the following ratings checked: (.*)/ do |rating_list|
  rating_list.split(%r{\s*,\s*}).each do |name, val|
    assert_equal(has_checked_field?("ratings_#{name}"), false, 'checkbox checked')
  end
end


