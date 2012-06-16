module Rst
  module CLI
    extend self

    def run(options, args = [])
      command      = args[0]
      rest_of_args = args[1, args.length]

      updates      = send(command, options, rest_of_args)

      puts updates.join("\n\n")
    rescue Exception => e
      puts e.message
      exit 1
    end

    def world(params = {}, args = [])
      statuses(:messages_all, params)
    end

    def user(params = {}, args = [])
      username = args[0]
      raise "Username is required." unless username
      statuses(:messages_user, params.merge(:username => username))
    end

    def statuses(which, params = {})
      statuses = []
      page     = 0
      num      = params[:num] || 20

      while statuses.size < num do
        page += 1
        messages = Rst::Client.send(which, params.merge(:page => page))

        break if messages.empty?

        statuses.concat messages
      end

      statuses.take(num)
    end
  end
end