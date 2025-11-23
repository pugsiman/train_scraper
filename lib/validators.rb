# Basic validators for the scraped values with the intention of guaranteeing data integrity.
# A slightly more interesting way of implementing this could be injecting the RSpec DSL for explicit value assertions.

module Validators
  class << self
    def string(value)
      value.is_a?(String) && !value.empty?
    end

    def minutes(value)
      value.is_a?(Integer) && value.positive?
    end

    def changeovers(value)
      value.is_a?(Integer)
    end

    def cents(value)
      value.is_a?(Integer)
    end

    def date(value)
      value.is_a?(DateTime)
    end

    def array_of_strings(value)
      value.is_a?(Array) && value.all? { |v| !v.empty? && v.is_a?(String) }
    end

    def currency(value)
      value.is_a?(String) && value.length == 3
    end

    def fares(value)
      value.is_a?(Array) && value.all? do |fare|
        currency(fare[:currency]) && string(fare[:name]) && cents(fare[:price_in_cents])
      end
    end
  end
end
