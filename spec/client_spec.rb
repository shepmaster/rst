require 'minitest/autorun'
require_relative 'vcr_setup'

describe "client" do
  before do
    @client = Rst::Client.new
  end

  describe "base_uri" do
    it "is https://rstat.us by default" do
      @client.base_uri.must_equal "https://rstat.us"
    end

    it "can be changed to a different URI" do
      uri = "http://example.com"
      Rst::Client.new(uri).base_uri.must_equal uri
    end
  end

  describe "messages_all" do
    describe "successful requests" do
      it "gets the root URL, follows the a rel=messages-all, gets updates" do
        VCR.use_cassette("successful_messages_all") do
          @client.messages_all.size.must_equal 20
        end
      end

      it "can find a rel=messages-all with other rels, not match false substrings" do
        VCR.use_cassette("successful_messages_all_multiple_rels") do
          @client.messages_all.size.must_equal 20
        end
      end
    end

    describe "multiple pages" do
      it "follows the next links to get the page number requested" do
        VCR.use_cassette("successful_messages_all_page_2") do
          page_1 = @client.messages_all
          page_2 = @client.messages_all(:page => 2)

          page_1.map(&:text).wont_equal page_2.map(&:text)
        end
      end
    end
  end

  describe "messages_user" do
    describe "successful requests" do
      it "looks up the user and gets their updates" do
        VCR.use_cassette("successful_messages_user") do
          @client.messages_user(
            :username => "carols10cents"
          ).size.must_equal 20
        end
      end
    end
  end

  describe "users_search" do
    it "finds users with the given pattern" do
      VCR.use_cassette("users_search_with_results") do
        @client.users_search(
          :pattern => "ca"
        ).size.must_equal 20
      end
    end
  end
end