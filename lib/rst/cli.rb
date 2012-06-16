module Rst
  module CLI
    extend self

    def run(args = [], options = {})
      if args.first == "world"
        updates = world(options)
        puts updates.join("\n\n")
      end
    end

    def world(params = {})
      statuses = []
      page = 0
      num = params[:num] || 20

      while statuses.size < num do
        page += 1
        messages = Rst::Client.messages_all(:page => page)

        break if messages.empty?

        statuses.concat messages
      end

      statuses.take(num)
    end
  end
end