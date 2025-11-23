module Formatters
  class << self
    def string(value)
      value.strip
    end

    def integer(value)
      Integer(value)
    end

    def date(value)
      DateTime.parse(value)
    end

    def minutes(value)
      matches = value.scan(/\d+/)
      hours = matches[0].to_i
      minutes = matches[1].to_i
      (hours * 60) + minutes
    end

    # ...
  end
end
