module HandTypes
  module StraightFlush
    def rank; 0; end
  end

  module FourOfAKind
    def rank; -1; end
  end

  module FullHouse
    def rank; -2; end
  end

  module Flush
    def rank; -3; end
  end

  module Straight
    def rank; -4; end
  end

  module ThreeOfAKind
    def rank; -5; end
  end

  module TwoPair
    def rank; -6; end
  end

  module Pair
    def rank; -7; end
  end

  module HighCard
    def rank; -8; end
  end
end
