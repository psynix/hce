module Hooroo

  describe Date do
    def self.month_name_at(month)
      Date::DAYS_IN_MONTHS.keys[month - 1].capitalize
    end

    it 'errors without a argument' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it 'errors when the date value string is malformed' do
      date_string = 'a malformed date'
      expect { described_class.new(date_string) }.to raise_error(MalformedDateStringError)
    end

    it 'initialises with a valid date string' do
      date_string = '18 06 2009'
      expect { described_class.new(date_string) }.to_not raise_error
    end

    describe 'date constituent parts validations' do
      describe 'year' do
        it 'errors with a date before 1900' do
          expect { described_class.new('31 12 1899') }.to raise_error(DateOutOfRangeError, "Year '1899' is not between 1900 and 2010")
        end

        it 'errors with a date on after the year 2010' do
          expect { described_class.new('01 01 2011') }.to raise_error(DateOutOfRangeError, "Year '2011' is not between 1900 and 2010")
        end
      end

      describe 'month' do
        it 'errors with a month value less than 1' do
          expect { described_class.new('01 00 2000') }.to raise_error(DateOutOfRangeError, "Month '0' is not between 1 and 12")
        end

        it 'errors with a date on after the year 2010' do
          expect { described_class.new('01 13 2000') }.to raise_error(DateOutOfRangeError, "Month '13' is not between 1 and 12")
        end
      end

      describe 'day' do
        describe 'for months with 31 days' do
          [1, 3, 5, 7, 8, 10, 12].each do |month|
            it "errors with a month value less than 1 for #{month_name_at(month)}" do
              expect { described_class.new('00 %02d 2000' % month) }.to raise_error(DateOutOfRangeError, "Day must be between 1 and 31 for month #{month} of year 2000")
            end

            it "does not allow more than 31 days for month #{month_name_at(month)}" do
              date_string = '32 %02d 1970' % month
              expect { described_class.new(date_string) }.to raise_error(DateOutOfRangeError, "Day must be between 1 and 31 for month #{month} of year 1970")
            end
          end
        end

        describe 'for months with 30 days' do
          [4, 6, 9, 11].each do |month|
            it "errors with a month value less than 1 for #{month_name_at(month)}" do
              expect { described_class.new('00 %02d 2000' % month) }.to raise_error(DateOutOfRangeError, "Day must be between 1 and 30 for month #{month} of year 2000")
            end

            it "does not allow more than 30 days for #{month_name_at(month)}" do
              date_string = '31 %02d 1970' % month
              expect { described_class.new(date_string) }.to raise_error(DateOutOfRangeError, "Day must be between 1 and 30 for month #{month} of year 1970")
            end
          end
        end

        describe 'february' do
          context 'common year' do
            let(:not_leap_years) do
              [1900, 2010]
            end

            it 'permits a day up to day 28 for all leap years' do
              not_leap_years.each do |year|
                date_string = "28 02 #{year}"
                expect { described_class.new(date_string) }.to_not raise_error
              end
            end

            it 'errors when the day supplied it more than 28' do
              not_leap_years.each do |year|
                date_string = "29 02 #{year}"
                expect { described_class.new(date_string) }.to raise_error(DateOutOfRangeError, "Day must be between 1 and 28 for month 2 of year #{year}")
              end
            end
          end

          context 'leap years' do
            # All leap years between 1900 and 2010
            let(:all_leap_years) do
              [
                  1904, 1908, 1912, 1916, 1920, 1924, 1928, 1932, 1936, 1940,
                  1944, 1948, 1952, 1956, 1960, 1964, 1968, 1972, 1976, 1980,
                  1984, 1988, 1992, 1996, 2000, 2004, 2008
              ]
            end

            it 'permits a day up to day 29 for all leap years' do
              all_leap_years.each do |year|
                date_string = "29 02 #{year}"
                expect { described_class.new(date_string) }.to_not raise_error
              end
            end

            it 'permits a day up to day 29 for all leap years' do
              all_leap_years.each do |year|
                date_string = "30 02 #{year}"
                expect { described_class.new(date_string) }.to raise_error(DateOutOfRangeError, "Day must be between 1 and 29 for month 2 of year #{year}")
              end
            end
          end
        end
      end
    end

    describe '#days_since_epoch' do
      describe 'same year as epoch' do
        it 'returns 0 for 1st Jan 1900' do
          date_string = '01 01 1900'
          expect(described_class.new(date_string).days_since_epoch).to eq(0)
        end

        it 'returns 1 for 2nd Jan 1900' do
          date_string = '02 01 1900'
          expect(described_class.new(date_string).days_since_epoch).to eq(1)
        end

        it 'returns 59 for 1st Mar 1900' do
          date_string = '01 03 1900'
          expect(described_class.new(date_string).days_since_epoch).to eq(59)
        end

        it 'returns 1825 for 31st Dec 1904' do
          date_string = '31 12 1900'
          expect(described_class.new(date_string).days_since_epoch).to eq(364)
        end
      end

      describe 'common years in the future' do
        it 'returns 365 for 1st Jan 1901' do
          date_string = '01 01 1901'
          expect(described_class.new(date_string).days_since_epoch).to eq(365)
        end

        it 'returns 366 for 2nd Jan 1901' do
          date_string = '02 01 1901'
          expect(described_class.new(date_string).days_since_epoch).to eq(366)
        end

        it 'returns 424 for 1st Mar 1900' do
          date_string = '01 03 1901'
          expect(described_class.new(date_string).days_since_epoch).to eq(424)
        end

        it 'returns 720 for 31st Dec 1904' do
          date_string = '31 12 1901'
          expect(described_class.new(date_string).days_since_epoch).to eq(729)
        end
      end

      context 'leap years in the future' do
        it 'returns 1460 for 1st Jan 1904' do
          date_string = '01 01 1904'
          expect(described_class.new(date_string).days_since_epoch).to eq(1460)
        end

        it 'returns 1461 for 2nd Jan 1904' do
          date_string = '02 01 1904'
          expect(described_class.new(date_string).days_since_epoch).to eq(1461)
        end

        it 'returns 1520 for 1st Mar 1904' do
          date_string = '01 03 1904'
          expect(described_class.new(date_string).days_since_epoch).to eq(1520)
        end

        it 'returns 1825 for 31st Dec 1904' do
          date_string = '31 12 1904'
          expect(described_class.new(date_string).days_since_epoch).to eq(1825)
        end
      end
    end

    describe '#to_s' do
      let(:input_date) { '01 01 1970' }

      subject { described_class.new(input_date) }

      it 'matches the input string' do
        expect("#{subject}").to eq(input_date)
      end
    end
  end
end
