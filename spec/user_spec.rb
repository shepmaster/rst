require 'minitest/autorun'
require 'rst'

describe "user" do
  describe "Rst::User.new" do
    it "requires a non-blank username" do
      lambda { Rst::User.new(:path => "foo") }.must_raise(KeyError)
      lambda { Rst::User.new(:path => "foo", :username => "") }.must_raise(
        Rst::InvalidUser
      )
    end

    it "requires a non-blank path" do
      lambda { Rst::User.new(:username => "foo") }.must_raise(KeyError)
      lambda { Rst::User.new(:username => "foo", :path => "") }.must_raise(
        Rst::InvalidUser
      )
    end

    it "does not require a full_name" do
      Rst::User.new(
        :username => "foo",
        :path     => "bar"
      ).full_name.must_equal("")

      Rst::User.new(
        :username  => "foo",
        :path      => "bar",
        :full_name => ""
      ).full_name.must_equal("")
    end

    it "does not require a description" do
      Rst::User.new(
        :username => "foo",
        :path     => "bar"
      ).description.must_equal("")

      Rst::User.new(
        :username    => "foo",
        :path        => "bar",
        :description => ""
      ).description.must_equal("")
    end
  end

  describe "Rst::User.parse" do
    it "can parse a status from an li that conforms to the ALPS spec" do
      li = Nokogiri::HTML.parse(
        <<-HERE
        <li class='even user'>
          <div class='info'>
            <a href='/users/Carols10cents' rel='user messages'>
              <span class='user-name'>
                Carol Nichols
              </span>
              (<span class="user-text">Carols10cents</span>)
            </a>
            <div class='bio'>
              <span class='description'>
                 I love Ruby
              </span>
            </div>
          </div>
        </li>
        HERE
      )
      user = Rst::User.parse(li)
      user.username.must_equal("Carols10cents")
      user.path.must_equal("/users/Carols10cents")
      user.full_name.must_equal("Carol Nichols")
      user.description.must_equal("I love Ruby")
    end

    it "can parse a user link even if there are multiple rels and false substring matches" do
      li = Nokogiri::HTML.parse(
        <<-HERE
        <li class='even user'>
          <div class='info'>
            <a href="/foo" rel='not-user'>Wrong link</a>
            <a href='/users/Carols10cents' rel='user messages'>
              <span class="user-text">Carols10cents</span>
            </a>
          </div>
        </li>
        HERE
      )
      user = Rst::User.parse(li)
      user.path.must_equal("/users/Carols10cents")
    end


    it "does not raise an error if optional elements are not present" do
      li = Nokogiri::HTML.parse(
        <<-HERE
        <li class='even user'>
          <div class='info'>
            <a href='/users/Carols10cents' rel='user messages'>
              <span class="user-text">Carols10cents</span>
            </a>
          </div>
        </li>
        HERE
      )
      user = Rst::User.parse(li)
      user.username.must_equal("Carols10cents")
      user.path.must_equal("/users/Carols10cents")
      user.full_name.must_equal("")
      user.description.must_equal("")
    end

    it "raises an error if the required user link is not present" do
      li = Nokogiri::HTML.parse(
        <<-HERE
        <li class='even user'>
          <div class='info'>
            <a href='/users/Carols10cents' rel='messages'>
              <span class="user-text">Carols10cents</span>
            </a>
          </div>
        </li>
        HERE
      )

      lambda { user = Rst::User.parse(li) }.must_raise(Rst::InvalidUser)
    end

    it "raises an error if the required username is not present" do
      li = Nokogiri::HTML.parse(
        <<-HERE
        <li class='even user'>
          <div class='info'>
            <a href='/users/Carols10cents' rel='user messages'>
              <span>Carols10cents</span>
            </a>
          </div>
        </li>
        HERE
      )
      lambda { user = Rst::User.parse(li) }.must_raise(Rst::InvalidUser)
    end
  end
end