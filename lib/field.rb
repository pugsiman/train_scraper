require 'validators'
require 'formatters'

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
    # some fields can already be assumed to be pre formatted from the source
    @result = Formatters.send(type, @result) if Formatters.respond_to?(type)
  rescue StandardError => e
    raise FormattingError, "Failed to format result: '#{result}' for field: '#{name}' (#{e.message})"
  end

  def validate!
    # we should always implement an apropriate validator
    unless Validators.respond_to?(type)
      raise NotImplementedError, "A validator for field #{name} has to be implemented in validators.rb"
    end

    valid = Validators.send(type, @result)
    raise InvalidResultError, "Invalid result: '#{@result}' for field: '#{name}'" unless valid
  end
end
