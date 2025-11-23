module Formatters
  class << self
    def string(value)
      value.strip
    end

    def date(value)
      DateTime.parse(value)
    end

    # ...
  end
end
