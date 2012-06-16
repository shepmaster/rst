require 'minitest/autorun'
require 'mocha'

require 'rst'

describe "world" do
  before do
    @cli = Rst::CLI
  end

  it "gets the world updates" do
    page_of_updates = 20.times.map { "Hi"}
    Rst::Client.expects(:messages_all).once.returns(page_of_updates)

    @cli.world.size.must_equal(20)
  end

  it "can specify a number of world updates to get" do
    Rst::Client.stubs(:messages_all).returns(["Hi", "Bye", "Yo"])
    @cli.world(:num => 2).size.must_equal(2)
  end

  it "gets as many updates as it can but stops if there arent more" do
    Rst::Client.stubs(:messages_all).returns(["Hi", "Bye", "Yo"], [])
    @cli.world(:num => 5).size.must_equal(3)
  end

  it "should have Rst::Statuses" do
    Rst::Client.stubs(:messages_all).returns([
      Rst::Status.new(:username => "ueoa", :text => "foo!")
    ])
    @cli.world(:num => 1).first.to_s.must_equal("ueoa: foo!")
  end
end
