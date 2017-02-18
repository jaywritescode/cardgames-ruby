require 'minitest/autorun'
require 'set'
require 'pry-byebug'

require_relative 'poker_hand'
require_relative 'cards'

class TestPokerHand < Minitest::Test

  def test_straight_flush
    hand = PokerHand.new random_straight_flush(size: 7)
    assert hand.straight_flush?, "Expected #{hand.to_s} to be a straight flush"
  end

  def test_four_of_a_kind
    hand = PokerHand.new random_four_of_a_kind(size: 7)
    assert hand.four_of_a_kind?, "Expected #{hand.to_s} to be a four of a kind"
  end

  def test_full_house?
    hand = PokerHand.new random_full_house(size: 7)
    assert hand.full_house?, "Expected #{hand.to_s} to be a full house"
  end

  def test_flush?
    hand = PokerHand.new random_hand_flush(size: 7)
    assert hand.flush?, "Expected #{hand.to_s} to be a flush"
  end

  def test_straight?
    hand = PokerHand.new random_hand_straight(size: 7)
    assert hand.straight?, "Expected #{hand.to_s} to be a straight"
  end

  def test_three_of_a_kind?
    hand = PokerHand.new random_hand_three_of_a_kind(size: 7)
    assert hand.three_of_a_kind?, "Expected #{hand.to_s} to be three of a kind"
  end

  def test_two_pair?
    hand = PokerHand.new random_hand_more_than_one_pair(size: 7)
    assert hand.two_pair?, "Expected #{hand.to_s} to be two pair"
  end

  def test_pair?
    hand = PokerHand.new random_hand_one_pair(size: 7)
    assert hand.pair?, "Expected #{hand.to_s} to be one pair"
  end

  def test_high_card?
    hand = PokerHand.new random_hand_no_pairs(size: 7)
    assert hand.high_card?, "Expected #{hand.to_s} to be no pairs"
  end

  def test_compare
    sf = PokerHand.new %w(5H 6H 7H 8H 9H TH AS).shuffle.map { |e| Card::from_str(e) }
    foak = PokerHand.new %w(QS QD QC QH 3S 3D 8D).shuffle.map { |e| Card::from_str(e) }
    fh = PokerHand.new %w(3D 3S 3C JD JC 6H 4D).shuffle.map { |e| Card::from_str(e) }
    flush = PokerHand.new %w(6S QS JS 2S 5S 6C JD).shuffle.map { |e| Card::from_str(e) }
    str = PokerHand.new %w(5D 6D 7D 8H 9D 3S 6C).shuffle.map { |e| Card::from_str(e) }
    toak = PokerHand.new %w(9C 9D 9S 4D JC AD 8H).shuffle.map { |e| Card::from_str(e) }
    tp = PokerHand.new %w(4C 4D AD AH 7C 7H QD).shuffle.map { |e| Card::from_str(e) }
    p = PokerHand.new %w(KD KC 4C 8S 9D JS 2H).shuffle.map { |e| Card::from_str(e) }
    hc = PokerHand.new %w(5C 9D KS 4H 7C TD 3H).shuffle.map { |e| Card::from_str(e) }

    test_hands = [sf, foak, fh, flush, str, toak, tp, p, hc]
    lo, hi = (0..8).to_a.sample(2).sort!

    assert (lo <=> hi) < 0
  end

  def test_compare_straight_flush
    skip
    lo, hi = (3...13).to_a.sample(2).sort!.map do |idx|
      PokerHand.new make_straight_flush(high_card_rank_idx: idx)
    end

    assert (lo <=> hi) < 0, "Expected #{hi.to_s} to beat #{lo.to_s}"
  end

  def test_compare_straight_flush
    lo, hi = (3..13).to_a.sample(2).sort!.map do |idx|
      PokerHand.new make_straight_flush(high_card_rank_idx: idx)
    end

    assert (lo <=> hi) < 0, "Expected #{hi.to_s} to beat #{lo.to_s}"
  end

  def random_hand_straight_flush(size: 5)
    cards_needed = [size, 5].min
    flush_suit = random_suit

    high_index = ((cards_needed - 2)...13).to_a.sample
    cards = (0...cards_needed).map do |i|
      Card.new(Card::ranks[high_index - i], flush_suit)
    end

    return cards if cards.count >= size

    deck = Card::create_deck.reject {|card| cards.include?(card)}
    cards += deck.sample(size - 5)
  end

  def make_straight_flush(high_card_rank_idx:, size: 5)
    cards_needed = [size, 5].min
    flush_suit = random_suit

    cards = (0...cards_needed).map do |i|
      Card.new(Card::ranks[high_card_rank_idx - i], flush_suit)
    end

    return cards if cards.count >= size

    deck = Card::create_deck.reject {|card| cards.include?(card)}
    cards += deck.sample(size - 5)
  end

  def random_hand_flush(size: 5)
    flush_suit = random_suit
    cards = Card::ranks.sample([size, 5].min).map do |rank|
      Card.new(rank, flush_suit)
    end

    return cards if cards.count >= size

    cards += Card::create_deck.reject do |card|
      cards.include?(card)
    end.sample(size - cards.count)
  end

  def random_hand_straight(size: 5)
    cards_needed = [size, 5].min

    high_index = ((cards_needed - 2)...13).to_a.sample
    cards = (0...5).map do |i|
      Card.new(Card::ranks[high_index - i], random_suit)
    end

    return cards if cards.count >= size

    deck = Card::create_deck.reject {|card| cards.include?(card)}
    cards += deck.sample(size - 5)
  end

  def random_hand_four_of_a_kind(size: 5)
    n_rank = random_rank
    cards = Card::suits.map do |suit|
      Card.new(n_rank, suit)
    end

    deck = Card::create_deck.reject {|card| card.rank == n_rank}
    cards += deck.sample(size - 4)
  end

  def random_hand_full_house(size: 5)
    trip_rank, pair_rank = *(Card::ranks.sample(2))
    cards = Card::suits.sample(3).map do |suit|
      Card.new(trip_rank, suit)
    end
    cards += Card::suits.sample(2).map do |suit|
      Card.new(pair_rank, suit)
    end

    deck = Card::create_deck.reject do |card|
      card.rank == trip_rank || cards.include?(card)
    end
    cards += deck.sample(size - 5)
  end

  def random_hand_three_of_a_kind(size: 5)
    trip_rank = random_rank
    cards = Card::suits.sample(3).map do |suit|
      Card.new(trip_rank, suit)
    end

    Card::ranks.select {|r| r != trip_rank}.sample(size - 3).each do |r|
      cards << Card.new(r, random_suit)
    end
    cards
  end

  def random_hand_more_than_one_pair(size: 5)
    raise unless size >= 4

    pair_ranks = Card::ranks.sample(2)
    cards = pair_ranks.flat_map do |rank|
      Card::suits.sample(2).map do |suit|
        Card.new(rank, suit)
      end
    end

    return cards unless size > 4

    # prevents three of a kind
    deck = Card::create_deck.delete_if do |card|
      pair_ranks.include?(card.rank) || [:hearts, :spades].include?(card.suit)
    end

    cards += deck.sample(size - 4)
  end

  def random_hand_one_pair(size: 5)
    pair_rank = random_rank
    cards = Card::suits.sample(2).map do |suit|
      Card.new(pair_rank, suit)
    end

    Card::ranks.select {|r| r != pair_rank}.sample(size - 2).each do |r|
      cards << Card.new(r, random_suit)
    end
    cards
  end

  def random_hand_no_pairs(size: 5)
    Card::ranks.sample(size).inject([]) do |acc, rank|
      acc << Card.new(rank, random_suit)
    end
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
