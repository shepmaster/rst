# Put your step definitions here

Then /^the output should contain (\d+) updates$/ do |num|
  num = num.to_i

  lines = all_output.split("\n")
  blank_lines = lines.select{|l| l == "" }
  non_blank_lines = lines - blank_lines

  blank_lines.size.should == num
  non_blank_lines.size.should == num
end
