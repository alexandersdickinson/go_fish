require('sinatra')
require('sinatra/reloader')
require('./lib/card')
require('./lib/hand')
require('./lib/deck')
require('./lib/go_fish_player')
require('./lib/go_fish_game')
also_reload('lib/**/*.rb')

get('/') do
  @header = "Go Fish"
  @games = GoFishGame.all()
  erb(:index)
end

post('/') do
  @header = "Go Fish"
  GoFishGame.delete(GoFishGame.find(params.fetch('id').to_i()))
  @games = GoFishGame.all()
  erb(:index)
end

post('/new') do
  @header = "New Game"
  @new_game = GoFishGame.new(params.fetch('player_count').to_i())
  @new_game.save()
  erb(:new)
end

post('/new/:id') do
  @game = GoFishGame.find(params.fetch('id').to_i())
  @game.players().each_index() do |i|
    @game.players()[i].name=(params.fetch("player-name#{i}"))
  end
  @current_player = @game.current_player()
  @active_players = @game.active_players()
  current_player_index = @active_players.index(@current_player)
  @checked_index = current_player_index == 0 ? 1 : 0
  @header = "#{@game.current_player().name()}\'s Turn"
  erb(:form)
end

get('/:id/form') do
  @game = GoFishGame.find(params.fetch('id').to_i())
  if @game.active_players().length() < 2
    @header = "Game Over"
    erb(:game_over)
  else
    @message = nil
    @current_player = @game.current_player()
    if @current_player.hand().cards().length() == 0 && @game.deck().count() > 0
      @game.turn(nil, nil)
      @message = "Your cards have been replenished."
    end
    @current_player = @game.current_player()
    @active_players = @game.active_players()
    current_player_index = @active_players.index(@current_player)
    @checked_index = current_player_index == 0 ? 1 : 0
    @header = "#{@game.current_player().name()}\'s Turn"
    erb(:form)
  end
end

post('/:id/result') do
  @header = "Result"
  @game = GoFishGame.find(params.fetch('id').to_i())
  target_card = Card.new({:suit => "spades", :value => params.fetch('player-card')})
  target_player = @game.players()[params.fetch('target-player').to_i()]
  target_player_last_hand = target_player.hand().cards().length()
  @result = @game.turn(target_player, target_card)
  target_player_current_hand = target_player.hand().cards().length()
  @current_player = @game.current_player()
  if @result == :card_found
    cards_found = target_player_last_hand - target_player_current_hand
    @message = "You retrieved #{cards_found} card#{"s" if cards_found > 1} with the value #{target_card.value().capitalize()} from #{target_player.name()}. Click continue to resume your turn."
    @fish = false
  else
    @message = "No card with the value #{target_card.value().capitalize()} was found. It is now #{@current_player.name()}\'s turn."
    @fish = true if @game.deck().count() > 0
  end
  @card_found
  erb(:result)
end

post('/:id/go_fish') do
  @game = GoFishGame.find(params.fetch('id').to_i())
  last_player_index = params.fetch('current-player').to_i()
  player_index = last_player_index != (@game.active_players().length() - 1) ? last_player_index + 1 : 0
  @card = @game.active_players()[player_index].hand().cards()[-1]
  @header = "You Caught a#{"n" if @card.value() == "8" || @card.value() == "ace"}..."
  erb(:go_fish)
end