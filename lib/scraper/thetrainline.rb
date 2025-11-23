# frozen_string_literal: true

module Scraper
  class Thetrainline < Scraper::Base
    def self.find(from, to, departure_at)
      resource.map do |segment|
        new(from, to, departure_at).scrape(segment)
      end
    end

    protected

    def fields
      [
        departure_station,
        departure_at,
        arrival_station,
        arrival_at,
        service_agencies,
        duration_in_minutes,
        changeovers,
        products,
        fares
      ]
    end

    # NOTE: for the case of demonstration, the html page for the segments is mocked.
    # typically, it would make more sense to create an abstraction (rather than relying on implementing this method) for the type of resource,
    # which could be an HTML page, an API json response, both (as fallbacks), or something else.
    # in this case, directly calling the API seems a lot easier than the web scraper this exercise calls for.
    class << self
      def resource
        uri = URI('http://example.com/page_mock.html')
        page = Mechanize::Page.new(uri, nil, File.read('spec/page_mock.html'), 200, Mechanize.new)
        page.search("[data-test^='eu-journey-row-'][data-test$='-wrapper']")
      end
    end

    def departure_station
      Field.new(__method__, :string, lambda { |segment|
        segment.search('[data-test="time-and-duration"] > div')[1].at('span').text
      })
    end

    def departure_at
      Field.new(__method__, :date, lambda { |segment|
        segment.search('[data-test="journey-times"] time')[0]['datetime']
      })
    end

    def arrival_station
      Field.new(__method__, :string, lambda { |segment|
        segment.search('[data-test="time-and-duration"] > div')[1].search('span').last.text
      })
    end

    def arrival_at
      Field.new(__method__, :date, lambda { |segment|
        segment.search('[data-test="journey-times"] time')[-1]['datetime']
      })
    end

    def service_agencies
      Field.new(__method__, :array_of_strings, lambda { |segment|
        segment.search('[data-testid="carrier-logo-container"] img @title').map(&:to_s)
      })
    end

    def duration_in_minutes
      Field.new(__method__, :minutes, lambda { |segment|
        segment.at('[data-test="journey-details-link"] [aria-hidden="true"]').text
      })
    end

    def changeovers
      Field.new(__method__, :integer, lambda { |segment|
        segment.search('[data-test="journey-details-link"] > span').last.text[/\d+/]
      })
    end

    def products
      Field.new(__method__, :array_of_strings, lambda { |_segment|
        ['train']
      })
    end

    def fares
      Field.new(__method__, :fares, lambda { |segment|
        standard = segment.at('[data-test="standard-ticket-price"] > span')&.text&.strip
        first_class = segment.at('[data-test="first-class-ticket-price"] > span')&.text&.strip

        [[standard, 'standard'], [first_class, 'first class']].map do |element, name|
          next unless element

          {
            name: name,
            price_in_cents: Integer(Float(element[/\d*\.?\d+/]) * 100),
            currency: element[/[^A-Za-z0-9]+/]
          }
        end.compact
      })
    end
  end
end
