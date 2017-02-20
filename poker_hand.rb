require 'set'
require_relative 'cards'
require_relative 'hand_types'

class PokerHand
  include Comparable

  def initialize(array_of_cards)
    @cards = array_of_cards
    @size = array_of_cards.count
    set_type_of_hand
  end

  def set_type_of_hand
    case
    when straight_flush? then self.extend HandTypes::StraightFlush
    when four_of_a_kind? then self.extend HandTypes::FourOfAKind
    when full_house? then self.extend HandTypes::FullHouse
    when flush? then self.extend HandTypes::Flush
    when straight? then self.extend HandTypes::Straight
    when three_of_a_kind? then self.extend HandTypes::ThreeOfAKind
    when two_pair? then self.extend HandTypes::TwoPair
    when pair? then self.extend HandTypes::Pair
    else self.extend HandTypes::HighCard
    end
  end

  # Gets the best five-card hand from the given cards.
  #
  # @return [Array<Card>] the cards in the hand
  def best_hand
    raise
  end

  # Does this hand contain a straight flush?
  def straight_flush?
    relevant_ranks = cards_by_suit.values.find {|suited| suited.count >= cards_needed}

    return unless relevant_ranks

    relevant_ranks = relevant_ranks.sort!.map(&:rank).reverse!

    return true if relevant_ranks.include?(:ace) &&
      relevant_ranks.to_set.superset?(Card::ranks.take(cards_needed - 1).to_set)

    relevant_ranks.each_cons(cards_needed).any? do |cons|
      Card::rank_index(cons.first) - Card::rank_index(cons.last) == cards_needed - 1
    end
  end

  # Does this hand contain a four of a kind?
  def four_of_a_kind?
    cards_by_rank.values.first.count == 4
  end

  # Does this hand contain a full house?
  def full_house?
    the_cards = cards_by_rank.values
    the_cards[0].count == 3 && the_cards[1].count >= 2
  end

  # Does this hand contain a flush?
  def flush?
    cards_by_suit.any? {|_, v| v.count >= cards_needed}
  end

  # Does this hand contain a straight?
  def straight?
    ranks_in_hand = cards_sorted_ace_high.map(&:rank).uniq

    return true if ranks_in_hand.include?(:ace) &&
      ranks_in_hand.to_set.superset?(Card::ranks.take(cards_needed - 1).to_set)

    ranks_in_hand.each_cons(cards_needed).any? do |cons|
      Card::rank_index(cons.first) - Card::rank_index(cons.last) == cards_needed - 1
    end
  end

  # Does this hand contain a triplet and no pairs?
  def three_of_a_kind?
    the_cards = cards_by_rank.values
    the_cards[0].count == 3 && the_cards[1].count < 2
  end

  # Does this hand contain two or more pairs and no trips or quads?
  def two_pair?
    the_cards = cards_by_rank.values
    the_cards[0].count == 2 && the_cards[1].count == 2
  end

  # Does this hand contain a single pair and no trips or quads?
  def pair?
    the_cards = cards_by_rank.values
    the_cards[0].count == 2 && the_cards[1].count < 2
  end

  # Does this hand have only singleton ranks? Note that this method can return
  # true if the hand has a flush or straight.
  def high_card?
    cards_by_rank.count == @size
  end

  def to_s
    cards_by_rank.values.flatten.map(&:to_s).join(", ")
  end

  def <=>(other)
    if self.rank == other.rank
      self.best_hand <=> other.best_hand
    else
      self.rank <=> other.rank
    end
  end

  def cards
    @cards
  end

  protected

  def ace_low_straight(sorted_cards: cards_sorted_ace_high)
    u = cards_sorted_ace_high.uniq(&:rank)
    u.drop(@size - cards_needed + 1) << u.first
  end

  private

  # Sorts the cards by rank.
  #
  # @return [Array<Card>] the cards sorted by rank
  def cards_sorted_ace_high
    @cards_sorted_ace_high ||= @cards.sort!.reverse!
  end

  # Groups all the cards in the hand by rank.
  #
  # @return [Hash] a hash where the keys are the ranks and the values are arrays of cards with that rank, sorted by count then rank
  def cards_by_rank
    @cards_by_rank ||= @cards.group_by(&:rank).sort do |b,a|
      cmp_key_a, cmp_key_b = [a, b].map {|entry| entry[1]}

      cmp = cmp_key_a.count <=> cmp_key_b.count
      cmp.zero? ? cmp_key_a.first <=> cmp_key_b.first : cmp
    end.to_h
  end

  # Groups all the cards in the hand by suit.
  #
  # @return [Hash] a hash where the keys are the suits and the values are arrays of cards with that suit
  def cards_by_suit
    @cards_by_suit ||= @cards.group_by(&:suit)
  end

  # The number of cards needed to complete a straight or flush
  # in this hand.
  #
  # @return [Integer] the number of cards needed to complete this hand
  def cards_needed
    [@size, 5].min
  end
end
