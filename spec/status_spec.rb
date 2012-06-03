require 'minitest/autorun'
require 'rst'

describe "status" do
  describe "#to_s" do
    before do
      @status = Rst::Status.new(:text => "I made an update", :username => "aoeu")
    end

    it "has the username and status text" do
      @status.to_s.must_equal(
        "aoeu: I made an update"
      )
    end
  end

  describe "Rst::Status.parse" do
    it "can parse a status from an li that conforms to the ALPS spec" do
      li = Nokogiri::HTML.parse(
        <<-HERE
        <li class="hentry message update">
          <div class="author vcard">
            <span class="nickname user-text">user123</span>
          </div>
          <div class="entry-content">
            <span class="message-text">Hello world!</span
          </div>
        </li>
        HERE
      )
      status = Rst::Status.parse(li)
      status.text.must_equal("Hello world!")
      status.username.must_equal("user123")
    end

    it "makes whitespace pretty" do
      li = Nokogiri::HTML.parse(
        <<-HERE
        <li>
          <span class="nickname user-text">user123</span>
          <span class="message-text">
            Hello

            world!
          </span
        </li>
        HERE
      )
      status = Rst::Status.parse(li)
      status.text.must_equal("Hello world!")
      status.username.must_equal("user123")
    end
  end
end
