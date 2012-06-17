require 'nokogiri'
require 'typhoeus'

module Rst
  module Client
    extend self

    def base_uri
      "http://rstat.us"
    end

    def messages_all(params = {:page => 1})
      root_response = Nokogiri::HTML.parse(
        Typhoeus::Request.get(base_uri).body
      )

      link = root_response.xpath(
        "//a[contains(@rel, 'messages-all')]"
      ).first

      uri = (URI(base_uri) + URI(link["href"])).to_s

      all_response = Nokogiri::HTML.parse(
        Typhoeus::Request.get(uri).body
      )

      messages = all_response.css("div#messages ul.all li").map { |li|
                   Rst::Status.parse(li)
                 }

    end

    def messages_user(params = {})
      root_response = Nokogiri::HTML.parse(
        Typhoeus::Request.get(base_uri).body
      )

      users_search_link = root_response.xpath(
        "//a[contains(@rel, 'users-search')]"
      ).first

      users_search_uri = (URI(base_uri) + URI(users_search_link["href"])).to_s

      users_search_response = Nokogiri::HTML.parse(
        Typhoeus::Request.get(users_search_uri).body
      )

      form = users_search_response.css("form.users-search").first
      search_uri = (URI(base_uri) + URI(form["action"])).to_s

      user_lookup_query = "#{search_uri}?search=#{params[:username]}"

      user_lookup_response = Nokogiri::HTML.parse(
        Typhoeus::Request.get(user_lookup_query).body
      )

      search_results = user_lookup_response.css("div#users ul.search li.user")

      result = search_results.detect { |sr|
        sr.css("span.user-text").first.text.strip.match(/^#{params[:username]}$/i)
      }

      user_link = result.xpath(".//a[contains(@rel, 'user')]").first

      user_uri = (URI(base_uri) + URI(user_link["href"])).to_s

      user_response = Nokogiri::HTML.parse(
        Typhoeus::Request.get(user_uri).body
      )

      messages = user_response.css("div#messages ul.messages-user li").map { |li|
                   Rst::Status.parse(li)
                 }

    end

    def hydra
      Typhoeus::Hydra.hydra
    end
  end
end