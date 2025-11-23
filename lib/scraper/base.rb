# frozen_string_literal: true

module Scraper
  class Base
    class NoResultsError < StandardError; end

    def scrape(resource)
      results = fields.map do |field|
        field.parse!(resource)
        field.format!
        field.validate!

        [field.name, field.result]
      end

      Hash[results]
    end

    def scrape!
      scrape.tap do |results|
        raise NoResultsError if results.empty?
      end
    end

    protected

    def fields
      []
    end

    def resource
      # e.g.:
      # agent = Mechanize.new
      # @resource = agent.get(url)
      raise NotImplementedError
    end
  end
end
