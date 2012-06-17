module Rst
  class User
    attr_reader :username, :full_name, :description, :path

    def initialize(params = {})
      @username    = cleanup_whitespace(params[:username])
      @full_name   = cleanup_whitespace(params[:full_name])
      @description = cleanup_whitespace(params[:description])
      @path        = cleanup_whitespace(params[:path])
    end

    def to_s
      "#{@username} (#{display_full_name}): #{display_description}"
    end

    def display_full_name
      if @full_name.nil? || @full_name == ""
        "No full name"
      else
        @full_name
      end
    end

    def display_description
      if @description.nil? || @description == ""
        "No bio"
      else
        @description
      end
    end

    def self.parse(li)
      new(
        :username    => li.css("span.user-text").text,
        :full_name   => li.css("span.user-name").text,
        :description => li.css("span.description").text,
        :path        => li.xpath(".//a[contains(@rel, 'user')]").first["href"]
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