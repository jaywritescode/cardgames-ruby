require 'set'

class Card
  include Comparable

  RANKS = {
    two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8,
    nine: 9, ten: 10, jack: 11, queen: 12, king: 13, ace: 14
  }
  SUITS = [:clubs, :diamonds, :hearts, :spades]

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    (RANKS[@rank] - RANKS[other.rank]) <=> 0
  end

  def to_s
    "#{rank.to_s} of #{suit.to_s}"
  end

  def ==(other)
    @rank == other.rank && @suit == other.suit
  end

  def self.value(card)
    Card::RANKS[card.rank]
  end

  def self.from_str(str)
    r, s = str.each_char.to_a
    Card.new Card::rank_strings[r], Card::suit_strings[s]
  end

  def self.create_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::RANKS.keys.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
    deck
  end

  def self.rank_index(rank)
    RANKS[rank] - 2
  end

  private

  def self.rank_strings
    @rank_strings ||= {
      '2' => :two,
      '3' => :three,
      '4' => :four,
      '5' => :five,
      '6' => :six,
      '7' => :seven,
      '8' => :eight,
      '9' => :nine,
      'T' => :ten,
      'J' => :jack,
      'Q' => :queen,
      'K' => :king,
      'A' => :ace
    }
  end

  def self.suit_strings
    @suit_strings ||= {
      'C' => :clubs,
      'D' => :diamonds,
      'H' => :hearts,
      'S' => :suits
    }
  end
end
