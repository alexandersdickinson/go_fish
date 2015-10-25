class Deck
  attr_reader(:deck, :count)
  
  def initialize()
    @deck = []
    @count = 52
    suits = %w(spades clubs diamonds hearts)
    values = %w(ace 2 3 4 5 6 7 8 9 10 jack queen king)
    suits.each() do |suit|
      values.each() do |value|
        card = Card.new({:suit => suit, :value => value})
        @deck.push(card)
      end
    end
  end
  
  def draw()
    @count = @count - 1
    @deck.pop()
  end
  
  def shuffle()
    @deck.shuffle!()
  end
end