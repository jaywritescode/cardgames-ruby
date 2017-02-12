require 'set'

class Card
  include Comparable

  RANKS = [
    :two, :three, :four, :five, :six, :seven, :eight,
    :nine, :ten, :jack, :queen, :king, :ace
  ].freeze
  RANK_VALUES = Hash[RANKS.zip(2..14)].freeze
  SUITS = [:clubs, :diamonds, :hearts, :spades].freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    (self.value - other.value) <=> 0
  end

  def to_s
    "#{rank.to_s} of #{suit.to_s}"
  end

  def ==(other)
    @rank == other.rank && @suit == other.suit
  end

  def value
    Card::RANK_VALUES[rank]
  end

  def self.from_str(str)
    r, s = str.each_char.to_a
    Card.new Card::rank_strings[r], Card::suit_strings[s]
  end

  def self.create_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
    deck
  end

  def self.rank_index(rank)
    RANK_VALUES[rank] - 2
  end

  def self.ranks
    RANKS
  end

  def self.suits
    SUITS
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
