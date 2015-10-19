class GoFishGame
  @@games = []
  attr_reader(:player_count, :deck, :players, :current_player, :player_changes, :active_players, :winner, :id)

  def initialize(player_count)
    @id = @@games.length() + 1
    @player_count = player_count
    @deck = Deck.new()
    @deck.shuffle()
    @players = []
    @winner = []
    @player_count.times() { @players.push(GoFishPlayer.new(Hand.new())) }
    @active_players = @players
    @current_player = @players[0]
    @player_changes = 0
    @players.each() do |player|
      if @player_count < 5
        7.times() { player.hand().add(@deck.draw()) }
      else
        5.times() { player.hand().add(@deck.draw()) }
      end
    end
  end
  
  def turn(target_player, target_card)
    if @active_players.length() < 2
      max_books = 0
      @players.each() { |player| max_books = player.books() if player.books() > max_books }
      @players.each() { |player| @winner.push(player) if player.books() == max_books }
      return false
    else
      target_value = target_card.value()
      found_target = false
      target_player.hand().cards().each() do |card|
        if target_value == card.value()
          current_player.add_to_books(card)
          target_player.hand().remove(card)
          found_target = true
        end
      end
      if !found_target
        @player_changes = @player_changes + 1
        if @deck.count() > 0
          @current_player.hand().add(@deck.draw())
        else
          @active_players.delete(@current_player)
          @player_count = @player_count - 1
        end
        @current_player = @active_players[(@player_changes % @player_count)]
      end
    end
  end
  
  def self.all()
    @@games
  end
  
  def save()
    @@games.push(self)
  end
  
  def self.clear()
    @@games = []
  end
  
  def self.find(id)
    @@games.each() do |game|
      return game if game.id() == id
    end
  end
end