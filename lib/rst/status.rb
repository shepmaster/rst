module Rst
  class Status
    attr_reader :username, :text

    def initialize(params = {})
      @username = params[:username]
      @text     = params[:text]
    end

    def to_s
      "#{@username}: #{@text}"
    end
  end
end