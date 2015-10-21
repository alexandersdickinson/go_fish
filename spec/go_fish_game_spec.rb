require('rspec')
require('go_fish_game')

describe(GoFishGame) do
  before() do
    GoFishGame.clear()
  end
  
  describe('#save') do
    it('saves games') do
      test_game = GoFishGame.new(2)
      test_game.save()
      expect(GoFishGame.all()).to(eq([test_game]))
    end
  end
  
  describe('.clear') do
    it('deletes all games') do
      test_game1 = GoFishGame.new(2)
      test_game1.save()
      test_game2 = GoFishGame.new(2)
      test_game2.save()
      GoFishGame.clear()
      expect(GoFishGame.all()).to(eq([]))
    end
  end
  
  describe('.find') do
    it('fetches a game based on its id') do
      test_game1 = GoFishGame.new(2)
      test_game1.save()
      test_game2 = GoFishGame.new(2)
      test_game2.save()
      expect(GoFishGame.find(2)).to(eq(test_game2))
    end
  end
  
  describe('.all') do
    it('starts as an empty array') do
      expect(GoFishGame.all()).to(eq([]))
    end
  end
  
  describe('#player_count') do
    it('returns the number of players') do
      test_game = GoFishGame.new(3)
      expect(test_game.player_count()).to(eq(3))
    end
  end
  
  describe('#current_player') do
    it('assigns the first player in the list of players as the player with the first turn') do
      test_game = GoFishGame.new(3)
      expect(test_game.current_player()).to(eq(test_game.players()[0]))
    end
    
    it("changes the current player to the next player in the players array when the current player\'s target card is not found") do
      test_game = GoFishGame.new(2)
      next_player = test_game.players()[1]
      target_player = test_game.players()[1]
      target_card = Card.new({:value => "Fake", :suit => "Clubs"})
      test_game.turn(target_player, target_card)
      expect(next_player).to(eq(test_game.current_player()))
    end
  end
  
  describe('#active_players') do
    it('includes all players at the start of a game') do
      test_game = GoFishGame.new(2)
      expect(test_game.players()).to(eq(test_game.active_players()))
    end
  end
  
  describe('#player_changes') do
    it('starts at 0') do
      test_game = GoFishGame.new(3)
      expect(test_game.player_changes()).to(eq(0))
    end
    
    it('is incremented whenever the active player changes') do
      test_game = GoFishGame.new(2)
      target_player = test_game.players()[1]
      target_card = Card.new({:value => "Fake", :suit => "Clubs"})
      test_game.turn(target_player, target_card)
      expect(test_game.player_changes()).to(eq(1))
    end
  end
  
  describe('#players') do
    it('returns a player for each player in the game') do
      test_game = GoFishGame.new(3)
      expect(test_game.players().length()).to(eq(test_game.player_count()))
    end
    
    it('deals 7 cards to each player when the number of players is less than or equal to 4') do
      test_game = GoFishGame.new(3)
      test_game.players().each() do |player|
        expect(player.hand().cards().length()).to(eq(7))
      end
    end
    
    it('deals 5 cards to each player when the number of players is greater than 4') do
      test_game = GoFishGame.new(5)
      test_game.players().each() do |player|
        expect(player.hand().cards().length()).to(eq(5))
      end
    end
  end
  
  describe('#turn') do
    it("removes all cards of a particular value from the chosen player's hand") do
      test_game = GoFishGame.new(2)
      target_player = test_game.players[1]
      target_card = target_player.hand().cards()[0]
      test_game.turn(target_player, target_card)
      expect(target_player.hand().cards().include?(target_card)).to(eq(false))
    end
    
    it("continues as long as the chosen player has any cards of the desired value") do
      test_game = GoFishGame.new(2)
      target_player = test_game.players[1]
      target_card = target_player.hand().cards()[0]
      test_game.turn(target_player, target_card)
      target_card = target_player.hand().cards()[0]
      test_game.turn(target_player, target_card)
      expect(test_game.current_player()).to(eq(test_game.players()[0]))  
    end
    
    it("ends when the desired card is not found in the chosen player's hand") do
      test_game = GoFishGame.new(2)
      target_player = test_game.players()[1]
      target_card = Card.new({:value => "Fake", :suit => "Clubs"})
      test_game.turn(target_player, target_card)
      expect(test_game.current_player()).to(eq(test_game.players()[1]))
    end
    
    it("deals a card to a player when their desired card is not in the target player's hand") do
      test_game = GoFishGame.new(2)
      target_player = test_game.players()[1]
      target_card = Card.new({:value => "Fake", :suit => "Clubs"})
      test_game.turn(target_player, target_card)
      expect(test_game.players()[0].hand().cards().length()).to(eq(8))
    end
    
    it("adds a book to the players collection if they have 4 cards of the same value") do
      test_game = GoFishGame.new(10)
      test_game.players()[(1..9)].each() do |player|
        target_player = player
        while target_player.hand().cards().length() > 0
          target_card = target_player.hand.cards()[0]
          test_game.turn(target_player, target_card)
        end
      end
      expect(test_game.current_player().books() > 0).to(eq(true))
    end
    
    it("eliminates players that have empty hands when all cards have been drawn from the deck") do
      test_game = GoFishGame.new(3)
      false_card = Card.new({:value => "Fake", :suit => "Spades"})
      player1 = test_game.players()[0]
      player2 = test_game.players()[1]
      player3 = test_game.players()[2]
      target_card = nil
      while player3.hand().cards().length() > 0
        if test_game.current_player() == player1 || test_game.current_player() == player2
          found_card = false
          test_game.current_player().hand().cards().each() do |card1|
            player3.hand().cards().each() do |card2|
              if card1.value() == card2.value()
                target_card = card1
                found_card = true
                break
              end
            end
            break if found_card
          end
          if found_card
            result = test_game.turn(player3, target_card)
          else
            result = test_game.turn(player3, false_card)
          end
        else
          test_game.turn(player1, false_card)
        end
      end
      expect(test_game.active_players().length()).to(eq(2))
      expect(test_game.player_count()).to(eq(2))
    end
    
    it("it ends the game when all players but one are eliminated") do
      test_game = GoFishGame.new(10)
      result = nil
      player10 = test_game.players()[1]
      false_card = Card.new({:value => "Fake", :suit => "Spades"})
      target_card = nil
      while result != :game_over
        if test_game.current_player() != player10
          found_card = false
          test_game.current_player().hand().cards().each() do |card1|
            player10.hand().cards().each() do |card2|
              if card1.value() == card2.value()
                target_card = card1
                found_card = true
                break
              end
            end
            break if found_card
          end
          if found_card
            result = test_game.turn(player10, target_card)
          else
            result = test_game.turn(player10, false_card)
          end
        else
          result = test_game.turn(test_game.active_players()[0], false_card)
        end
      end
      test_winners = []
      max_books = 0
      test_game.players.each() { |player| max_books = player.books() if player.books() > max_books }
      test_game.players.each() { |player| test_winners.push(player) if player.books() == max_books }
      expect(test_game.winner()).to(eq(test_winners))
    end
  end
end