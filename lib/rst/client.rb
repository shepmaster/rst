require 'nokogiri'
require 'typhoeus'

module Rst
  module Client
    extend self

    def messages_all(params = {:page => 1})
      root_response = get_body(base_uri)

      link = root_response.xpath(
        "//a[contains(@rel, 'messages-all')]"
      ).first

      uri = (URI(base_uri) + URI(link["href"])).to_s

      all_response = get_body(uri)

      messages = all_response.css("div#messages ul.all li").map { |li|
                   Rst::Status.parse(li)
                 }

    end

    def messages_user(params = {})
      root_response = get_body(base_uri)

      users_search_link = root_response.xpath(
        "//a[contains(@rel, 'users-search')]"
      ).first

      users_search_uri = (URI(base_uri) + URI(users_search_link["href"])).to_s

      users_search_response = get_body(users_search_uri)

      form = users_search_response.css("form.users-search").first
      search_uri = (URI(base_uri) + URI(form["action"])).to_s

      user_lookup_query = "#{search_uri}?search=#{params[:username]}"

      user_lookup_response = get_body(user_lookup_query)

      search_results = user_lookup_response.css("div#users ul.search li.user")

      result = search_results.detect { |sr|
        sr.css("span.user-text").first.text.strip.match(/^#{params[:username]}$/i)
      }

      user_link = result.xpath(".//a[contains(@rel, 'user')]").first

      user_uri = (URI(base_uri) + URI(user_link["href"])).to_s

      user_response = get_body(user_uri)

      messages = user_response.css("div#messages ul.messages-user li").map { |li|
                   Rst::Status.parse(li)
                 }

    end

    private

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