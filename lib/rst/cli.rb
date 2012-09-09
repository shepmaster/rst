module Rst
  module CLI
    extend self

    def run(options, args = [])
      command      = args[0]
      rest_of_args = args[1, args.length]

      results      = send(command.gsub(/-/, "_"), options, rest_of_args)

      puts results.join("\n\n")
    rescue Exception => e
      puts "ERROR: #{e.message}"

      if options[:debug]
        puts e.backtrace.join("\n")
      else
        puts "Run with --trace for the full backtrace."
      end

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

    def users_search(params = {}, args = [])
      search_pattern = args[0]
      raise "Username search pattern is required." unless search_pattern
      users = Rst::Client.users_search(:pattern => search_pattern)
      if users.empty?
        ["No users that match."]
      else
        users.map{|u| Rst::UserPresenter.new(u) }
      end
    end

    private

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