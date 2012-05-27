require 'minitest/autorun'
require 'rst'

describe "status" do
  before do
    @status = Rst::Status.new(:text => "I made an update", :username => "aoeu")
  end

  describe "#to_s" do
    it "has the username and status text" do
      @status.to_s.must_equal(
        "aoeu: I made an update"
      )
    end
  end
end
