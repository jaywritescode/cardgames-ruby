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

  def straight_flush?
    cards = cards_by_suit.find {|cards| cards.count >= cards_needed}
    return unless cards

    cards.sort.reverse.map(&:rank).each_cons(cards_needed).any? do |list|
      Card::RANKS[list.first] - Card::RANKS[list.last] == cards_needed - 1
    end
  end

  # Does this hand contain four of a kind?
  def four_of_a_kind?
    cards_by_rank[0].count == 4
  end

  # Does this hand contain a full house?
  def full_house?
    cards_by_rank[0].count == 3 && cards_by_rank[1].count >= 2
  end

  # Does this hand contain a flush?
  def flush?
    cards_by_suit.any? {|cards| cards.count >= cards_needed}
  end

  # Does this hand contain a straight?
  def straight?
    return unless cards_rank_map.count >= cards_needed

    cards_rank_map.map(&:first).each_cons(cards_needed).any? do |list|
      Card::RANKS[list.first] - Card::RANKS[list.last] == cards_needed - 1
    end
  end

  # Does this hand contain a triplet and no pairs?
  def three_of_a_kind?
    cards_by_rank[0].count == 3 && cards_by_rank[1].count == 1
  end

  # Does this hand contain two or more pairs and no trips or quads?
  def two_pair?
    cards_by_rank[0].count == 2 && cards_by_rank[1].count == 2
  end

  # Does this hand contain a single pair and no trips or quads?
  def pair?
    cards_by_rank[0].count == 2 && cards_by_rank[1].count == 1
  end

  # Does this hand have only singleton ranks? Note that this method can return
  # true if the hand has a flush or straight.
  def high_card?
    cards_by_rank.all? {|r| r.count == 1}
  end

  def to_s
    cards_by_rank.map(&:to_s).join(", ")
  end

  def <=>(other)
    if self.rank == other.rank
      self.ranks_in_sort_order <=> other.ranks_in_sort_order
    else
      self.rank <=> other.rank
    end
  end

  def ranks_in_sort_order
    cards_by_rank.map {|c| c.first.rank}
  end

  private

  def cards_group_by_rank
    @cards_group_by_rank ||= @cards.group_by(&:rank)
  end

  # Gets a mapping of each rank to an array of cards with that rank,
  # sorted with ace high.
  def cards_rank_map
    @cards_rank_map ||= cards_group_by_rank.sort_by do |key, _|
      -(Card::RANKS[key])
    end
  end

  # Gets an array of card arrays, grouped by rank.
  def cards_by_rank
    @cards_by_rank ||= cards_group_by_rank.values.sort! do |b,a|
      cmp = a.count <=> b.count
      cmp.zero? ? a.first <=> b.first : cmp
    end
  end

  # Gets an array of card arrays, grouped by suit.
  def cards_by_suit
    @cards_by_suit ||= @cards.group_by(&:suit).values
  end

  def cards_needed
    [@size, 5].min
  end
end
