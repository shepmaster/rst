module Rst
  class Status
    attr_reader :username, :text

    def initialize(params = {})
      @username = cleanup_whitespace(params[:username])
      @text     = cleanup_whitespace(params[:text])
    end

    def to_s
      "#{@username}: #{@text}"
    end

    def self.parse(li)
      new(
        :username => li.css("span.user-text").text,
        :text     => li.css("span.message-text").text
      )
    end

    private

    def cleanup_whitespace(html_text)
      html_text.gsub(/\n/, ' ').squeeze(" ").strip
    end
  end
end