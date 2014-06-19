module Hooroo
  class Parser
    INPUT_LINE_REGEXP = /\A(?<start>.*),\s+(?<end>.*)\Z/

    def initialize(input_line)
      parsed_line = INPUT_LINE_REGEXP.match(input_line)

      raise MalformedDateStringError if parsed_line.nil?

      @start_date = Date.new(parsed_line[:start])
      @end_date   = Date.new(parsed_line[:end])
    end

    def to_s
      "#{@start_date}, #{@end_date}, #{difference}"
    end

    alias_method :to_str, :to_s

    private

    def difference
      @end_date - @start_date
    end
  end
end
