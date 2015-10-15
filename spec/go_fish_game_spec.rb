require('rspec')
require('go_fish_game')

describe(GoFishGame) do
  describe('#player_count') do
    it('returns the number of players') do
      test_game = GoFishGame.new(3)
      expect(test_game.player_count()).to(eq(3))
    end
  end
  
  describe('#hands') do
    it('returns a hand for each player in the game') do
      test_game = GoFishGame.new(3)
      expect(test_game.hands().length()).to(eq(test_game.player_count()))
    end
    
    it('deals 7 cards to each player when the number of players is less than or equal to 4') do
      test_game = GoFishGame.new(3)
      test_game.hands().each() do |hand|
        expect(hand.hand().length()).to(eq(7))
      end
    end
    
    it('deals 5 cards to each player when the number of players is greater than 4') do
      test_game = GoFishGame.new(5)
      test_game.hands().each() do |hand|
        expect(hand.hand().length()).to(eq(5))
      end
    end
  end
end