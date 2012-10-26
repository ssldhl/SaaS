# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/[\s,]+/).each do |rating|
    if uncheck
      step %Q{I uncheck "ratings[#{rating}]"}
    else
      step %Q{I check "ratings[#{rating}]"}
    end
  end
end

Then /^I should( not)? see the following ratings: (.*)$/ do |no, rating_list|
  rating_list.split(/[\s,]+/).each do |rating|
    if no
      assert page.has_no_xpath?('//td', :text => "#{rating}")
    else
      assert page.has_xpath?('//td', :text => "#{rating}")
    end
  end
  print page.html
end

Then /^I should see all of the movies$/ do
  rows = page.all('table#movies tr').count
  rows.should == 11
end

# Make sure that one string (regexp) occurs before or after another one
# on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  first = page.body.index(e1)
  second = page.body.index(e2)
  first.should < second
end
