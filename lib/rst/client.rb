require 'nokogiri'
require 'typhoeus'

module Rst
  module Client
    extend self

    def messages_all(params = {:page => 1})
      messages_all_path = find_a_in(root_response, :rel => "messages-all")
      messages_all_uri = resolve_relative_uri(
        :relative => messages_all_path,
        :base     => base_uri
      )

      all_response = get_body(messages_all_uri)
      current_uri = messages_all_uri

      (params[:page] - 1).times do
        next_page_path = find_a_in(all_response, :rel => "next")
        current_uri = resolve_relative_uri(
          :relative => next_page_path,
          :base     => current_uri
        )
        all_response = get_body(current_uri)
      end

      messages = all_response.css("div#messages ul.all li").map { |li|
                   Rst::Status.parse(li)
                 }
    end

    def messages_user(params = {})
      search_results = users_search(:pattern => params[:username])

      result = search_results.detect { |sr|
        sr.username.match(/^#{params[:username]}$/i)
      }

      user_uri = resolve_relative_uri(
        :relative => result.path,
        :base     => base_uri
      )

      user_response = get_body(user_uri)

      message_nodes = user_response.css("div#messages ul.messages-user li")
      message_nodes.map { |li| Rst::Status.parse(li) }
    end

    def users_search(params = {})
      users_search_path = find_a_in(root_response, :rel => "users-search")
      users_search_uri = resolve_relative_uri(
        :relative => users_search_path,
        :base     => base_uri
      )

      users_search_response = get_body(users_search_uri)

      form = users_search_response.css("form.users-search").first
      search_uri = resolve_relative_uri(
        :relative => form["action"],
        :base     => users_search_uri
      )

      user_lookup_query = "#{search_uri}?search=#{params[:pattern]}"

      user_lookup_response = get_body(user_lookup_query)

      search_results = user_lookup_response.css("div#users ul.search li.user")
      search_results.map { |li| Rst::User.parse(li) }
    end

    private

    def find_a_in(html, params = {})
      raise "no rel specified" unless params[:rel]

      link = html.xpath(
        ".//a[contains(concat(' ', normalize-space(@rel), ' '), ' #{params[:rel]} ')]"
      ).first["href"]
    end

    def root_response
      get_body(base_uri)
    end

    def resolve_relative_uri(params = {})
      raise "no relative uri specified" unless params[:relative]
      raise "no base uri specified" unless params[:base]

      (URI(params[:base]) + URI(params[:relative])).to_s
    end

    def base_uri
      "https://rstat.us"
    end

    def get_body(uri)
      Nokogiri::HTML.parse(
        Typhoeus::Request.get(uri).body
      )
    end

    def hydra
      Typhoeus::Hydra.hydra
    end
  end
end