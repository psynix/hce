module Hooroo

  class MalformedDateStringError < StandardError; end
  class DateOutOfRangeError < StandardError; end

  class Date
    DATE_STRING_REGEXP = /(?<day>\d{2}) (?<month>\d{2}) (?<year>\d{4})/

    MONTHS = %i(january february march april may june july august september october november december)
    DAYS_IN_MONTH = [
        31,                                           # January
        ->(year) { is_leap_year?(year) ? 29 : 28 },   # February
        31,                                           # March
        30,                                           # April
        31,                                           # May
        30,                                           # June
        31,                                           # July
        31,                                           # August
        30,                                           # September
        31,                                           # October
        30,                                           # November
        31                                            # December
    ]

    EPOCH_YEAR        = 1900
    VALID_MONTH_RANGE = Range.new(1, DAYS_IN_MONTH.length)
    VALID_YEAR_RANGE  = Range.new(EPOCH_YEAR, 2010)

    attr_reader :day, :month, :year

    def initialize(date_string)
      parsed_date = DATE_STRING_REGEXP.match(date_string)

      raise MalformedDateStringError if parsed_date.nil?

      @year  = validated_year   parsed_date[:year ]
      @month = validated_month  parsed_date[:month]
      @day   = validated_day    parsed_date[:day  ]
    end

    def days_since_epoch
      Range.new(EPOCH_YEAR, @year, true).reduce(0) { |sum, y| sum += days_in_year(y) } + days_since_start_of_year
    end

    def to_s
      '%02d %02d %4d' % [day, month, year]
    end

    private

    class << self
      def is_leap_year?(year)
        return false  unless  (year %   4).zero?    # Common year
        return true   unless  (year % 100).zero?    # Leap year
        return false  unless  (year % 400).zero?    # Common year
        true                                        # Leap year
      end
    end

    def days_in_year(year)
      DAYS_IN_MONTH.reduce(0) do |sum, month_days|
        sum += if month_days.respond_to?(:call)
                 month_days.call(year)
               else
                 month_days
               end
      end
    end

    def days_since_start_of_year
      DAYS_IN_MONTH[0...(@month - 1)].reduce(0) do |sum, month_days|
        sum += if month_days.respond_to?(:call)
                 month_days.call(@year)
               else
                 month_days
               end
      end + day - 1
    end

    def validated_year(year)
      integer_value_for(year).tap do |value|
        raise DateOutOfRangeError, "Year '#{value}' is not between #{VALID_YEAR_RANGE.first} and #{VALID_YEAR_RANGE.last}" unless VALID_YEAR_RANGE.include?(value)
      end
    end

    def validated_month(month)
      integer_value_for(month).tap do |value|
        raise DateOutOfRangeError, "Month '#{value}' is not between #{VALID_MONTH_RANGE.first} and #{VALID_MONTH_RANGE.last}" unless VALID_MONTH_RANGE.include?(value)
      end
    end

    def validated_day(day)
      integer_value_for(day).tap do |value|
        valid_day_range = day_in_month_range(month)
        raise DateOutOfRangeError, "Day must be between #{valid_day_range.first} and #{valid_day_range.last} for month #{month} of year #{year}" unless valid_day_range.include?(value)
      end
    end

    def integer_value_for(value_string)
      Integer(value_string.sub(/\A0/, ''))      # Remove leading 0's to avoid value being treated as an octal
    end

    def day_in_month_range(month)
      days_in_month = DAYS_IN_MONTH[month - 1]

      if days_in_month.respond_to?(:call)
        Range.new(1, days_in_month.call(year))
      else
        Range.new(1, days_in_month)
      end
    end
  end
end
