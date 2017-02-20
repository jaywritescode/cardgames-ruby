module HandTypes
  module StraightFlush
    def rank; 0; end

    def best_hand
      relevant_cards = cards_by_suit
        .values
        .find {|c| c.count >= cards_needed}
        .sort
        .reverse!

      relevant_cards
        .each_cons(cards_needed)
        .find(lambda { ace_low_straight(sorted_cards: relevant_cards) }) do |cons|
          Card::rank_index(cons.first.rank) - Card::rank_index(cons.last.rank) == cards_needed - 1
        end
    end
  end

  module FourOfAKind
    def rank; -1; end

    def best_hand
      return cards unless cards.count > 5

      quads = cards_by_rank.values.first
      quads_rank = quads.first.rank

      quads << cards_by_rank.values[1..-1].flatten.max
    end
  end

  module FullHouse
    def rank; -2; end

    def best_hand
      return cards unless cards.count > 5

      cards_by_rank.values[0..1].flatten
    end
  end

  module Flush
    def rank; -3; end

    def best_hand
      cards_by_suit
        .values
        .find {|c| c.count >= cards_needed}
        .sort![-cards_needed..-1]
        .reverse!
    end
  end

  module Straight
    def rank; -4; end

    def best_hand
      cards_sorted_ace_high
        .uniq(&:rank)
        .each_cons(cards_needed)
        .find(ace_low_straight) do |cons|
          Card::rank_index(cons.first.rank) - Card::rank_index(cons.last.rank) == cards_needed - 1
        end
    end
  end

  module ThreeOfAKind
    def rank; -5; end

    def best_hand
      cards = cards_by_rank.values.find {|c| c.count == 3}
      cards << cards_sorted_ace_high.reject { |card| card.rank == cards.first.rank }[0..(cards_needed - 3)]
    end
  end

  module TwoPair
    def rank; -6; end

    def best_hand
      f = cards_by_rank.values.flatten
      pairs, others = f.slice(0, 4), f[4..-1]
      pairs << others.sort![-1]
    end
  end

  module Pair
    def rank; -7; end

    def best_hand
      cards_by_rank.values.flatten[0..(cards_needed - 2)]
    end
  end

  module HighCard
    def rank; -8; end

    def best_hand
      cards_sorted_ace_high[0..cards_needed]
    end
  end
end
