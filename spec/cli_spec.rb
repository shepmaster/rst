require 'minitest/autorun'
require 'mocha'

require 'rst'

describe "Rst::CLI" do
  before do
    @cli = Rst::CLI
  end

  describe "world" do
    it "gets the world updates" do
      page_of_updates = 20.times.map { "Hi" }
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

  describe "user" do
    def username
      "carols10cents"
    end

    it "gets one user's updates" do
      page_of_updates = 20.times.map { "Hi" }

      Rst::Client.expects(:messages_user).
                  once.
                  with({:username => username, :page => 1}).
                  returns(page_of_updates)

      @cli.user({}, [username]).size.must_equal(20)
    end

    it "can specify a number of one user's updates to get" do
      Rst::Client.stubs(:messages_user).returns(["Hi", "Bye", "Yo"])
      @cli.user({:num => 2}, username).size.must_equal(2)
    end

    it "requires a username" do
      lambda { @cli.user }.must_raise(RuntimeError)
    end

  end

  describe "users_search" do
    it "searches for that pattern" do
      users = ["one", "two"]

      Rst::Client.expects(:users_search).
                  once.
                  with({:pattern => "o"}).
                  returns(users)
      @cli.users_search({}, "o").size.must_equal(2)
    end

    it "requires a pattern" do
      lambda { @cli.users_search }.must_raise(RuntimeError)
    end
  end

end