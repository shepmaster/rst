module Rst
  module CLI
    extend self

    def world(num = 20)
      statuses = []

      while statuses.size < num do
        statuses.concat(["Hi"])
      end

      statuses
    end
  end
end