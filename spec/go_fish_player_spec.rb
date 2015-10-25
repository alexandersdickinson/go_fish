require('rspec')
require('go_fish_player')

describe(GoFishPlayer) do
  describe('#books') do
    it('initializes a player with 0 books') do
      test_player = GoFishPlayer.new(Hand.new())
      expect(test_player.books()).to(eq(0))
    end
  end
  
  describe('#add_to_books') do
    it('adds a card to an array of collected cards if there are not three other cards of the same value already') do
      test_player = GoFishPlayer.new(Hand.new())
      test_card = Card.new({:value => 3, :suit => "Diamonds"})
      test_player.hand().add(test_card)
      test_player.add_to_books()
      expect(test_player.hand().cards().include?(test_card)).to(eq(true))
    end
    
    it('increases the book count of a player when 4 cards of the same value are in their collection of cards') do
      test_player = GoFishPlayer.new(Hand.new())
      test_player.hand().add(Card.new({:value => 3, :suit => "diamonds"}))
      test_player.hand().add(Card.new({:value => 3, :suit => "clubs"}))
      test_player.hand().add(Card.new({:value => 3, :suit => "hears"}))
      test_player.hand().add(Card.new({:value => 3, :suit => "spades"}))
      test_player.add_to_books()
      expect(test_player.books()).to(eq(1))
    end
    
    it('removes all cards of the same value from a hand when a book is created') do
      test_player = GoFishPlayer.new(Hand.new())
      test_player.hand().add(Card.new({:value => 3, :suit => "diamonds"}))
      test_player.hand().add(Card.new({:value => 3, :suit => "clubs"}))
      test_player.hand().add(Card.new({:value => 3, :suit => "hears"}))
      test_player.hand().add(Card.new({:value => 3, :suit => "spades"}))
      test_player.add_to_books()
      expect(test_player.hand().cards()).to(eq([]))
    end
  end
end