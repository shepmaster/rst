require 'minitest/autorun'
require 'rst'

describe "world" do
  before do
    @cli = Rst::CLI
  end

  it "gets the world updates" do
    @cli.world.size.must_equal(20)
  end

  it "can specify a number of world updates to get" do
    @cli.world(2).size.must_equal(2)
  end
end
