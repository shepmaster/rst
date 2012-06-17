require 'nokogiri'
require 'typhoeus'

module Rst
  module Client
    extend self

    def messages_all(params = {:page => 1})
      link = root_response.xpath(
        "//a[contains(@rel, 'messages-all')]"
      ).first

      uri = resolve_relative_uri(link["href"])

      all_response = get_body(uri)

      messages = all_response.css("div#messages ul.all li").map { |li|
                   Rst::Status.parse(li)
                 }

    end

    def messages_user(params = {})
      users_search_link = root_response.xpath(
        "//a[contains(@rel, 'users-search')]"
      ).first

      users_search_uri = resolve_relative_uri(users_search_link["href"])

      users_search_response = get_body(users_search_uri)

      form = users_search_response.css("form.users-search").first
      search_uri = resolve_relative_uri(form["action"])

      user_lookup_query = "#{search_uri}?search=#{params[:username]}"

      user_lookup_response = get_body(user_lookup_query)

      search_results = user_lookup_response.css("div#users ul.search li.user")

      result = search_results.detect { |sr|
        sr.css("span.user-text").first.text.strip.match(/^#{params[:username]}$/i)
      }

      user_link = result.xpath(".//a[contains(@rel, 'user')]").first

      user_uri = resolve_relative_uri(user_link["href"])

      user_response = get_body(user_uri)

      messages = user_response.css("div#messages ul.messages-user li").map { |li|
                   Rst::Status.parse(li)
                 }

    end

    private

    def root_response
      get_body(base_uri)
    end

    def resolve_relative_uri(rel)
      (URI(base_uri) + URI(rel)).to_s
    end

    def base_uri
      "http://rstat.us"
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