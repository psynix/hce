module Hooroo

  module Utilities
    refine Array do
      def sum
        (dup << 0).inject(:+)
      end
    end
  end

end
