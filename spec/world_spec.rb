require 'minitest/autorun'
require 'mocha'

require 'rst'

describe "world" do
  before do
    @cli = Rst::CLI
  end

  it "gets the world updates" do
    Rst::Client.stubs(:messages_all).returns(["Hi"])

    @cli.world.size.must_equal(20)
  end

  it "can specify a number of world updates to get" do
    Rst::Client.stubs(:messages_all).returns(["Hi", "Bye", "Yo"])
    @cli.world(:num => 2).size.must_equal(2)
  end

  it "should have Rst::Statuses" do
    Rst::Client.stubs(:messages_all).returns([
      Rst::Status.new(:username => "ueoa", :text => "foo!")
    ])
    @cli.world(:num => 1).first.to_s.must_equal("ueoa: foo!")
  end
end
