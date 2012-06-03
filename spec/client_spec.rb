require 'minitest/autorun'
require_relative 'vcr_setup'

describe "messages_all" do
  describe "successful requests" do
    it "gets the root URL, follows the a rel=messages_all, gets updates" do
      VCR.use_cassette("successful_messages_all") do
        Rst::Client.messages_all.size.must_equal 20
      end
    end
  end
end
