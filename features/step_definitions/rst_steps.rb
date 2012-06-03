# Custom rst steps

Then /^the output should contain (\d+) updates$/ do |num|
  num = num.to_i

  lines = all_output.split("\n")
  non_blank_lines = lines.select{ |line| line.match(/\S+: \S+/) }

  non_blank_lines.size.should == num
end
