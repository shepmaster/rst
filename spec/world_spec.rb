require 'minitest/autorun'
require 'rst'

describe "world" do
  before do
    @cli = Rst::CLI.new
  end

  it "gets the world updates" do
    @cli.world.size.must_equal(20)
  end
end
