module Hooroo
  class MalformedDateStringError < StandardError; end
  class DateOutOfRangeError < StandardError; end

  class Date
    include Comparable

    using Utilities

    DATE_STRING_REGEXP = /\A(?<day>\d{2}) (?<month>\d{2}) (?<year>\d{4})\Z/

    DAYS_IN_MONTHS = {
        january: 31, february: '28 or 29', march: 31, april: 30, may: 31, june: 30,
        july:    31, august: 31, september: 30, october: 31, november: 30, december: 31
    }

    EPOCH_START_YEAR  = 1900
    VALID_MONTH_RANGE = Range.new(1, 12)
    VALID_YEAR_RANGE  = Range.new(EPOCH_START_YEAR, 2010)

    attr_reader :day, :month, :year

    def initialize(date_string)
      parsed_date = DATE_STRING_REGEXP.match(date_string)

      raise MalformedDateStringError if parsed_date.nil?

      @year  = validated_year parsed_date[:year]
      @month = validated_month parsed_date[:month]
      @day   = validated_day parsed_date[:day]
    end

    def days_since_epoch
      (EPOCH_START_YEAR...@year).map { |year| total_days_in_year(year) }.sum + days_since_start_of_year
    end

    def -(other)
      (days_since_epoch - other.days_since_epoch).abs
    end

    def <=>(other)
      days_since_epoch <=> other.days_since_epoch
    end

    def to_s
      '%02d %02d %4d' % [day, month, year]
    end

    private

    def validated_value_for_range(label, value_string, range)
      non_octal_integer_value_for(value_string).tap do |value|
        raise DateOutOfRangeError, "#{label} '#{value}' is not between #{range.first} and #{range.last}" unless range.include?(value)
      end
    end

    def validated_year(year_string)
      validated_value_for_range('Year', year_string, VALID_YEAR_RANGE)
    end

    def validated_month(month_string)
      validated_value_for_range('Month', month_string, VALID_MONTH_RANGE)
    end

    def validated_day(day)
      non_octal_integer_value_for(day).tap do |value|
        valid_day_range = Range.new(1, days_in_month_for_year(@year).at(month - 1))
        raise DateOutOfRangeError, "Day must be between #{valid_day_range.first} and #{valid_day_range.last} for month #{@month} of year #{@year}" unless valid_day_range.include?(value)
      end
    end

    def non_octal_integer_value_for(value_string)
      Integer(value_string.sub(/\A0/, '')) # Remove leading 0's to avoid value being treated as an octal
    end

    def days_in_month_for_year(year)
      DAYS_IN_MONTHS.merge(february: days_in_february_for_year(year)).values
    end

    def days_in_february_for_year(year)
      is_leap_year?(year) ? 29 : 28
    end

    def is_leap_year?(year)
      return false unless  (year % 4).zero? # Common year
      return true unless  (year % 100).zero? # Leap year
      return false unless  (year % 400).zero? # Common year
      true # Leap year
    end

    def total_days_in_year(year)
      days_in_month_for_year(year).sum
    end

    def days_since_start_of_year
      days_in_month_for_year(@year).first(@month - 1).sum + day - 1
    end
  end
end
