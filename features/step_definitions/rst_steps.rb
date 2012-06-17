# Custom rst steps

Then /^the output should contain (\d+) updates$/ do |num|
  num = num.to_i

  lines = all_output.split("\n")
  update_lines = lines.select{ |line| line.match(/\S+: \S+/) }

  update_lines.size.should == num
end

Then /^the output should contain (\d+) users$/ do |num|
  num = num.to_i

  lines = all_output.split("\n")
  user_lines = lines.select{ |line| line.match(/\S+ \(.+\): \S+/) }

  user_lines.size.should == num
end

Then /^the output should be the version$/ do
  all_output.should match(/^version \d+\.\d+.\d+$/)
end