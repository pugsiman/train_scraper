class Field
  class InvalidResultError < StandardError; end

  attr_reader :name, :type, :parser_func
  attr_accessor :result

  def initialize(name, type, parser_func)
    @name = name
    @type = type
    @parser_func = parser_func
  end

  def parse!(html)
    @result = parser_func.call(html)
  end

  def format!
    @result = Formatters.send(type, @result)
  end

  def validate!
    valid = Validators.send(type, @result)
    raise InvalidResultError.new(@result, name) unless valid
  end
end
