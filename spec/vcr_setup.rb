require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/data/vcr_cassettes"
  c.hook_into :typhoeus
end