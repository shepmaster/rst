module Rst
  module CLI
    extend self

    def run(args = [], options = {})
      if args[0] == "world"
        updates = world(options)
        puts updates.join("\n\n")
      elsif args[0] == "user"
        if args[1]
          updates = user(args[1], options)
          puts updates.join("\n\n")
        else
          puts "Username is required."
          exit 1
        end
      end
    end

    def world(params = {})
      statuses(:messages_all, [], params)
    end

    def user(username, params = {})
      statuses(:messages_user, username, params)
    end

    def statuses(which, args = [], params = {})
      statuses = []
      page = 0
      num = params[:num] || 20

      while statuses.size < num do
        page += 1
        messages = Rst::Client.send(which, args, :page => page)

        break if messages.empty?

        statuses.concat messages
      end

      statuses.take(num)
    end
  end
end