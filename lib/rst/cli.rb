module Rst
  module CLI
    extend self

    def world(num = 20)
      statuses = []
      page = 0

      while statuses.size < num do
        page += 1
        statuses.concat Rst::Client.messages_all(:page => page)
      end

      statuses.take(num)
    end
  end
end