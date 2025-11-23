module Scraper
  class Base
    class NoResultsError < StandardError; end

    class << self
      def find(from, to, departure_at)
        raise NotImplementedError
      end
    end

    attr_reader :page

    def initialize(url)
      @page = Mechanize.get(url)
    end

    def scrape
      results = fields.map do |field|
        field.parse!(page)
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
  end
end
