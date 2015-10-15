require('rspec')
require('deck')

describe(Deck) do
  describe('#count') do
    it('returns the number of cards in the deck') do
      test_deck = Deck.new()
      expect(test_deck.count()).to(eq(52))
    end
  end
  
  describe('#draw') do
    it('returns a card') do
      test_deck = Deck.new()
      expect(test_deck.draw().class()).to(eq(Card))
    end
    
    it('decrements the card count by one after a card is drawn') do
      test_deck = Deck.new()
      test_deck.draw()
      expect(test_deck.count()).to(eq(51))
    end
  end
  
  describe('#shuffle') do
    it('shuffles the deck') do
      initial_deck = Deck.new()
      shuffled_deck = initial_deck.shuffle()
      expect(initial_deck).not_to(eq(shuffled_deck))
    end
  end
end