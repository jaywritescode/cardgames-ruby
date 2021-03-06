require 'minitest/autorun'
require 'set'
require 'pry-byebug'

require_relative 'poker_hand'
require_relative 'cards'

class TestPokerHand < Minitest::Test

  def test_straight_flush
    hand = random_straight_flush(size: [3,4,5,7].sample)
    assert hand.straight_flush?, "Expected #{hand.to_s} to be a straight flush."
  end

  def test_four_of_a_kind
    hand = random_four_of_a_kind(size: [4,5,7].sample)
    assert hand.four_of_a_kind?, "Expected #{hand.to_s} to be four of a kind."
  end

  def test_full_house?
    hand = random_full_house(size: [5,7].sample)
    assert hand.full_house?, "Expected #{hand.to_s} to be a full house."
  end

  def test_flush?
    hand = random_flush(size: [3,4,5,7].sample)
    assert hand.flush?, "Expected #{hand.to_s} to be a flush."
  end

  def test_straight?
    hand = random_straight(size: [3,4,5,7].sample)
    assert hand.straight?, "Expected #{hand.to_s} to be a straight."
  end

  def test_three_of_a_kind?
    hand = random_three_of_a_kind(size: [3,4,5,7].sample)
    assert hand.three_of_a_kind?, "Expected #{hand.to_s} to have a three of a kind."
  end

  def test_two_pair?
    hand = random_two_pair(size: [4,5,7].sample)
    assert hand.two_pair?, "Expected #{hand.to_s} to have two pair."
  end

  def test_pair?
    hand = random_pair(size: [3,4,5,7].sample)
    assert hand.pair?, "Expected #{hand.to_s} to have one pair."
  end

  def test_high_card?
    hand = random_high_card_hand(size: [3,4,5,7].sample)
    assert hand.high_card?, "Expected #{hand.to_s} to be a high card hand."
  end

  def test_compare
    test_hands = [
      from_str(%w(5H 6H 7H 8H 9H TH AS)),
      from_str(%w(QS QD QC QH 3S 3D 8D)),
      from_str(%w(3D 3S 3C JD JC 6H 4D)),
      from_str(%w(6S QS JS 2S 5S 6C JD)),
      from_str(%w(5D 6D 7D 8H 9D 3S 6C)),
      from_str(%w(9C 9D 9S 4D JC AD 8H)),
      from_str(%w(4C 4D AD AH 7C 7H QD)),
      from_str(%w(KD KC 4C 8S 9D JS 2H)),
      from_str(%w(5C 9D KS 4H 7C TD 3H)),
    ]
    lo, hi = (0..8).to_a.sample(2).sort!

    assert (lo <=> hi) < 0
  end

  def test_compare_straight_flush
    lo = from_str %w(AD 2D 3D 4D 5D 6H 7S)
    hi = from_str %w(5C 6C 7C 8C 9C AD AH)

    assert (lo <=> hi) < 0
  end

  def test_compare_four_of_a_kind
    lo = from_str %w(6D 6C 6H 6S KS JS TS)
    hi = from_str %w(JS JC JD JH 4S TD 3C)

    assert (lo <=> hi) < 0

    lo = from_str %w(2C 2D 2S 2H 9C 5C 4D)
    hi = from_str %w(2C 2D 2S 2H TS 7C 3H)

    assert (lo <=> hi) < 0

    lo = from_str %w(2C 2D 2S 2H 9C 5C 4D)
    hi = from_str %w(2C 2D 2S 2H 9S 7C 3H)

    assert (lo <=> hi) == 0
  end

  def test_compare_full_house
    lo = from_str %w(8D 8C 8S KD KH JS 3H)
    hi = from_str %w(TC TD TS JD JH AC 6D)

    assert (lo <=> hi) < 0

    lo = from_str %w(4C 4D 4S TD TH 6S 7C)
    hi = from_str %w(4C 4D 4S 8C 8S JS JH)

    assert (lo <=> hi) < 0
  end

  def test_compare_flush
    lo = PokerHand.new %w(9S 3S 7S 2S 4S).map {|e| Card::from_str(e)}
    hi = PokerHand.new %w(3H 6H 7H 4H JH).map {|e| Card::from_str(e)}

    assert (lo <=> hi) < 0

    lo = PokerHand.new %w(4S JS 8S 9S 2S).map {|e| Card::from_str(e)}
    hi = PokerHand.new %w(3C 4C 5C JC TC).map {|e| Card::from_str(e)}

    assert (lo <=> hi) < 0

    lo = PokerHand.new %w(6S 9S AS KD JS 3S 4S).map {|e| Card::from_str(e)}
    hi = PokerHand.new %w(8C 5C AC KD JC 3D QC).map {|e| Card::from_str(e)}

    assert (lo <=> hi) < 0
  end

  def test_compare_straight
    lo = from_str %w(3S 4D 5D 6C 7H 9C JC)
    hi = from_str %w(3D 4C 5H 6H 7C 8D QS)

    assert (lo <=> hi) < 0
  end

  def test_compare_three_of_a_kind
    lo = PokerHand.new %w(9D 3H AD JC 9S 9C 5D).map {|e| Card::from_str(e)}
    hi = PokerHand.new %w(4S QC AH QD 2C QS 5H).map {|e| Card::from_str(e)}

    assert (lo <=> hi) < 0
  end

  def test_compare_two_pair
    lo = PokerHand.new %w(5H 9D 6C 6D KS 3H 5H).map {|e| Card::from_str(e)}
    hi = PokerHand.new %w(9H 7D 3C 3S 8D 4C 7C).map {|e| Card::from_str(e)}

    assert (lo <=> hi) < 0
  end

  def test_compare_pair
    lo = PokerHand.new %w(8C AD KS 9S 8D 3H 4C).map {|e| Card::from_str(e)}
    hi = PokerHand.new %w(7H JD JC 9D KC QS 3C).map {|e| Card::from_str(e)}

    assert (lo <=> hi) < 0
  end

  def random_straight_flush(size: 5)
    cards_needed = [size, 5].min
    high_index = ((cards_needed - 2)...13).to_a.sample
    make_straight_flush(high_card_rank_idx: high_index, size: size)
  end

  def make_straight_flush(high_card_rank_idx:, size: 5)
    cards_needed = [size, 5].min
    flush_suit = random_suit

    cards = (0...cards_needed).map do |i|
      Card.new(Card::ranks[high_card_rank_idx - i], flush_suit)
    end

    if cards.count < size
      deck = Card::create_deck.reject {|card| cards.include?(card)}
      cards += deck.sample(size - 5)
    end

    PokerHand.new cards.shuffle!
  end

  def random_four_of_a_kind(size: 5)
    make_four_of_a_kind(random_rank, size: size)
  end

  def make_four_of_a_kind(quad_rank, size: 5)
    cards = Card::suits.map do |suit|
      Card.new(quad_rank, suit)
    end

    if cards.count < size
      deck = Card::create_deck.reject {|card| cards.include?(card)}
      cards += deck.sample(size - 5)
    end

    PokerHand.new cards.shuffle!
  end

  def random_full_house(size: 5)
    make_full_house(random_rank, size: size)
  end

  def make_full_house(trip_rank, pair_rank: nil, size: 5)
    cards = Card::suits.sample(3).map do |suit|
      Card.new(trip_rank, suit)
    end
    cards += Card::suits.sample(2).map do |suit|
      Card.new(pair_rank ||= (Card::ranks - [trip_rank]).sample, suit)
    end

    if cards.count < size
      deck = Card::create_deck.reject {|card| cards.include?(card)}
      cards += deck.sample(size - 5)
    end

    PokerHand.new cards.shuffle!
  end

  def random_flush(size: 5)
    cards_needed = [size, 5].min
    make_flush(Card::ranks.sample(cards_needed), size: size)
  end

  def make_flush(ranks_array, size: 5)
    cards_needed = [size, 5].min
    flush_suit = random_suit

    ranks_array += (Card::ranks - ranks_array).sample(cards_needed - ranks_array.count) unless ranks_array.count == cards_needed

    cards = ranks_array.map { |rank| Card.new(rank, flush_suit) }

    if cards.count < size
      deck = Card::create_deck.reject {|card| cards.include?(card)}
      cards += deck.sample(size - 5)
    end

    PokerHand.new cards.shuffle!
  end

  def random_straight(size: 5)
    cards_needed = [size, 5].min
    make_straight(Card::ranks.drop(cards_needed - 2).sample, size: size)
  end

  def make_straight(high_rank, size: 5)
    cards_needed = [size, 5].min

    high_index = Card::rank_index(high_rank)
    cards = (0...cards_needed).map do |i|
      Card.new(Card::ranks[high_index - i], random_suit)
    end

    if cards.count < size
      deck = Card::create_deck.reject {|card| cards.include?(card)}
      cards += deck.sample(size - 5)
    end

    PokerHand.new cards.shuffle!
  end

  def random_three_of_a_kind(size: 5)
    make_three_of_a_kind(Card::ranks.sample, size: size)
  end

  def make_three_of_a_kind(trip_rank, size: 5)
    cards = Card::suits.sample(3).map do |suit|
      Card.new(trip_rank, suit)
    end

    deck = Card::create_deck.reject {|card| cards.include?(card)}

    PokerHand.new (cards + deck.sample(size - 3)).shuffle!
  end

  def random_two_pair(size: 5)
    make_two_pair([], size: 5)
  end

  def make_two_pair(pair_ranks, size: 5)
    pair_ranks += (Card::ranks - pair_ranks).sample([0, 2 - pair_ranks.count].max)
    cards = pair_ranks.collect_concat do |rank|
      Card::suits.sample(2).map do |suit|
        Card.new(rank, suit)
      end
    end

    if cards.count < size
      deck = Card::create_deck.reject {|card| cards.include?(card)}
      cards += deck.sample(size - cards.count)
    end

    PokerHand.new cards.shuffle!
  end

  def random_pair(size: 5)
    make_pair(Card::ranks.sample, size: size)
  end

  def make_pair(pair_rank, size: 5)
    cards = Card::suits.sample(2).map do |suit|
      Card.new(pair_rank, suit)
    end

    deck = Card::create_deck.reject {|card| cards.include?(card)}

    PokerHand.new (cards + deck.sample(size - cards.count)).shuffle!
  end

  def random_high_card_hand(size: 5)
    loop do
      ph = PokerHand.new (Card::ranks.sample(size).inject([]) do |acc, rank|
        acc << Card.new(rank, random_suit)
      end)
      break ph unless ph.flush? || ph.straight?
    end
  end

  def from_str(cards)
    PokerHand.new cards.shuffle.map { |e| Card::from_str(e) }
  end

  def random_hand_methods
    @random_hand_methods = [
      :random_hand_no_pairs,
      :random_hand_one_pair,
      :random_hand_more_than_one_pair,
      :random_hand_three_of_a_kind,
      :random_hand_straight,
      :random_hand_flush,
      :random_full_house,
      :random_four_of_a_kind,
      :random_straight_flush
    ]
  end

  def random_card(rank: nil, suit: nil)
    Card.new(rank || random_rank, suit || random_suit)
  end

  def random_rank
    Card::ranks.sample
  end

  def random_suit
    Card::suits.sample
  end
end
