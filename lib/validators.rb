# Basic validators for the scraped values with the intention of guaranteeing data integrity.
# A slightly more interesting way of implementing this could be injecting the RSpec DSL for explicit value assertions.

module Validators
  class << self
    def string(value)
      value.is_a?(String) && !value.empty?
    end

    def minutes(value)
      integer(value) && value.positive?
    end

    def integer(value)
      value.is_a?(Integer)
    end

    def cents(value)
      integer(value)
    end

    def date(value)
      value.is_a?(DateTime)
    end

    def array_of_strings(value)
      value.is_a?(Array) && value.all? { |v| string(v) }
    end

    def currency(value)
      string(value) && [1, 3].include?(value.length)
    end

    def fares(value)
      value.is_a?(Array) && value.all? do |fare|
        currency(fare[:currency]) && string(fare[:name]) && cents(fare[:price_in_cents])
      end
    end
  end
end
