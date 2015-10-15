require('card')
require('hand')
require('deck')

class GoFishGame
  attr_reader(:player_count, :deck, :hands)

  def initialize(player_count)
    @player_count = player_count
    @deck = Deck.new()
    @deck.shuffle()
    @hands = []
    @player_count.times() { @hands.push(Hand.new()) }
    @hands.each() do |hand|
      if @player_count < 5
        7.times() { hand.add(@deck.draw()) }
      else
        5.times() { hand.add(@deck.draw()) }
      end
    end
  end
end