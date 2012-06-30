module Rst
  class User
    attr_reader :username, :full_name, :description, :path

    def initialize(params)
      @username    = cleanup_whitespace(params.fetch(:username))
      if @username == ""
        raise Rst::InvalidUser.new("A non-blank username is required.")
      end

      @path        = cleanup_whitespace(params.fetch(:path))
      if @path == ""
        raise Rst::InvalidUser.new("A non-blank user path is required.")
      end

      @full_name   = cleanup_whitespace(params.fetch(:full_name, ""))
      @description = cleanup_whitespace(params.fetch(:description, ""))
    end

    def self.parse(li)
      new(
        :username    => li.css("span.user-text").text,
        :full_name   => li.css("span.user-name").text,
        :description => li.css("span.description").text,
        :path        => li.xpath(".//a[contains(@rel, 'user')]/@href").text
      )
    end

    private

    def cleanup_whitespace(html_text)
      if html_text
        html_text.gsub(/\n/, ' ').squeeze(" ").strip
      end
    end
  end
end