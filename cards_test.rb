require 'minitest/autorun'
require_relative 'cards'

class CardsTest < Minitest::Test

  def test_compare
    assert_equal(1, create_card(:jack, :spades) <=> create_card(:eight, :diamonds))
    assert_equal(0, create_card(:three, :clubs) <=> create_card(:three, :hearts))
    assert_equal(-1, create_card(:king, :clubs) <=> create_card(:ace, :clubs))
  end

  def test_equal
    assert_equal Card.new(:jack, :clubs), Card.new(:jack, :clubs)
  end

  def create_card(rank, suit)
    Card.new(rank, suit)
  end
end
