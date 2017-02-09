require 'minitest/autorun'
require 'set'

require_relative 'poker_hand'
require_relative 'cards'

class TestPokerHand < Minitest::Test

  def test_straight_flush?
    hand = PokerHand.new random_hand_straight_flush(size: 7)
    assert hand.straight_flush?, "Expected #{hand.to_s} to be a straight flush"
  end

  def test_four_of_a_kind?
    hand = PokerHand.new random_hand_four_of_a_kind(size: 7)
    assert hand.four_of_a_kind?, "Expected #{hand.to_s} to be four of a kind"
  end

  def test_full_house?
    hand = PokerHand.new random_hand_full_house(size: 7)
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

  def random_hand_straight_flush(size: 5)
    cards_needed = [size, 5].min
    flush_suit = random_suit

    high_index = ((cards_needed - 2)...13).to_a.sample
    cards = (0...5).map do |i|
      Card.new(Card::RANKS.keys[high_index - i], flush_suit)
    end

    return cards if cards.count >= size

    deck = Card::create_deck.reject {|card| cards.include?(card)}
    cards += deck.sample(size - 5)
  end

  def random_hand_flush(size: 5)
    flush_suit = random_suit
    cards = Card::RANKS.keys.sample([size, 5].min).map do |rank|
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
      Card.new(Card::RANKS.keys[high_index - i], random_suit)
    end

    return cards if cards.count >= size

    deck = Card::create_deck.reject {|card| cards.include?(card)}
    cards += deck.sample(size - 5)
  end

  def random_hand_four_of_a_kind(size: 5)
    n_rank = random_rank
    cards = Card::SUITS.map do |suit|
      Card.new(n_rank, suit)
    end

    deck = Card::create_deck.reject {|card| card.rank == n_rank}
    cards += deck.sample(size - 4)
  end

  def random_hand_full_house(size: 5)
    trip_rank, pair_rank = *(Card::RANKS.keys.sample(2))
    cards = Card::SUITS.sample(3).map do |suit|
      Card.new(trip_rank, suit)
    end
    cards += Card::SUITS.sample(2).map do |suit|
      Card.new(pair_rank, suit)
    end

    deck = Card::create_deck.reject do |card|
      card.rank == trip_rank || cards.include?(card)
    end
    cards += deck.sample(size - 5)
  end

  def random_hand_three_of_a_kind(size: 5)
    trip_rank = random_rank
    cards = Card::SUITS.sample(3).map do |suit|
      Card.new(trip_rank, suit)
    end

    Card::RANKS.keys.select {|r| r != trip_rank}.sample(size - 3).each do |r|
      cards << Card.new(r, random_suit)
    end
    cards
  end

  def random_hand_more_than_one_pair(size: 5)
    raise unless size >= 4

    pair_ranks = Card::RANKS.keys.sample(2)
    cards = pair_ranks.flat_map do |rank|
      Card::SUITS.sample(2).map do |suit|
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
    cards = Card::SUITS.sample(2).map do |suit|
      Card.new(pair_rank, suit)
    end

    Card::RANKS.keys.select {|r| r != pair_rank}.sample(size - 2).each do |r|
      cards << Card.new(r, random_suit)
    end
    cards
  end

  def random_hand_no_pairs(size: 5)
    Card::RANKS.keys.sample(size).inject([]) do |acc, rank|
      acc << Card.new(rank, random_suit)
    end
  end

  def random_card(rank: nil, suit: nil)
    Card.new(rank || random_rank, suit || random_suit)
  end

  def random_rank
    Card::RANKS.keys.sample
  end

  def random_suit
    Card::SUITS.sample
  end
end
