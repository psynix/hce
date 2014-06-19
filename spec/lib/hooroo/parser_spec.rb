module Hooroo
  describe Parser do
    describe 'initialisation' do
      it 'errors without a string argument' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end

      it 'initialises with properly formatted string argument' do
        expect { described_class.new('01 01 1900, 01 01 1900') }.to_not raise_error
      end

      context 'date(s) out of range' do
        it 'errors when the start date is before 1900' do
          expect { described_class.new('31 12 1899, 01 01 1900') }.to raise_error(DateOutOfRangeError)
        end

        it 'errors when the end date is after 2010' do
          expect { described_class.new('01 01 1900, 01 01 2011') }.to raise_error(DateOutOfRangeError)
        end
      end

      context 'malformed content' do
        it 'errors when the start date is missing' do
          expect { described_class.new(', 01 01 1904') }.to raise_error(MalformedDateStringError)
        end

        it 'errors when the end date is missing' do
          expect { described_class.new('01 01 1904, ') }.to raise_error(MalformedDateStringError)
        end

        it 'errors when there is only one date' do
          expect { described_class.new('01 01 1904') }.to raise_error(MalformedDateStringError)
        end

        it 'errors when input is empty or nil' do
          expect { described_class.new('') }.to raise_error(MalformedDateStringError)
          expect { described_class.new(nil) }.to raise_error(MalformedDateStringError)
        end
      end
    end

    describe '#to_s' do
      let(:inputs) do
        [
            '01 01 1900, 01 01 1900',
            '01 01 1900, 02 01 1900',
            '01 01 1900, 01 02 1900',
            '01 01 1900, 01 03 1900',
            '01 01 1900, 31 12 1900',
            '01 01 1900, 01 01 1901',
            '01 01 1900, 01 03 1904',
            '01 01 1904, 01 03 1908',
            '01 01 1900, 31 12 2010'
        ]
      end

      let(:expected_output) do
        [
            '01 01 1900, 01 01 1900, 0',
            '01 01 1900, 02 01 1900, 1',
            '01 01 1900, 01 02 1900, 31',
            '01 01 1900, 01 03 1900, 59',
            '01 01 1900, 31 12 1900, 364',
            '01 01 1900, 01 01 1901, 365',
            '01 01 1900, 01 03 1904, 1520',
            '01 01 1904, 01 03 1908, 1521',
            '01 01 1900, 31 12 2010, 40541'
        ]
      end

      it 'outputs the input with the difference between dates appended' do
        inputs.each_with_index do |input, idx|
          expect(described_class.new(input).to_s).to eq(expected_output[idx])
        end
      end
    end
  end
end
