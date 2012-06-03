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

      url = (URI(base_uri) + URI(link["href"])).to_s

      all_response = Nokogiri::HTML.parse(
        Typhoeus::Request.get(url).body
      )

      messages = all_response.css("div#messages ul.all li").map { |m|
                   Rst::Status.new(m)
                 }

    end

    def hydra
      Typhoeus::Hydra.hydra
    end
  end
end