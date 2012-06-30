module Rst
  class UserPresenter
    def initialize(user)
      @user = user
    end

    def to_s
      "#{@user.username} (#{full_name}): #{description}"
    end

    def full_name
      if @user.full_name == ""
        "No full name"
      else
        @user.full_name
      end
    end

    def description
      if @user.description == ""
        "No bio"
      else
        @user.description
      end
    end
  end
end