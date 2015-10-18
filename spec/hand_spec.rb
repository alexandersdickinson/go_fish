require('rspec')
require('hand')

describe(Hand) do
  describe('#add') do
    it('adds a card to the hand') do
      test_card = Card.new({:value => "Ace", :suit => "Hearts"})
      test_hand = Hand.new()
      test_hand.add(test_card)
      expect(test_hand.cards()[0]).to(eq(test_card))
    end
  end
  
  describe('#remove') do
    it('removes a card from the hand') do
      test_card = Card.new({:value => "Ace", :suit => "Hearts"})
      test_hand = Hand.new()
      test_hand.add(test_card)
      test_hand.remove(test_card)
      expect(test_hand.cards()).to(eq([]))
    end
    
    it('returns the deleted card if it is found') do
      test_card = Card.new({:value => "Ace", :suit => "Hearts"})
      test_hand = Hand.new()
      test_hand.add(test_card)
      expect(test_hand.remove(test_card)).to(eq(test_card))
    end
    
    it('returns nil if the card to be deleted is not found') do
      false_card = Card.new({:value => "King", :suit => "Spades"})
      test_card = Card.new({:value => "Ace", :suit => "Hearts"})
      test_hand = Hand.new()
      test_hand.add(test_card)
      expect(test_hand.remove(false_card)).to(eq(nil))
    end
  end
end