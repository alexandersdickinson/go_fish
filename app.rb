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
  @header = "#{@game.current_player().name()}\'s Turn"
  erb(:game)
end

get('/:id/form') do
  @game = GoFishGame.find(params.fetch('id').to_i())
  @current_player = @game.current_player()
  @active_players = @game.active_players()
  @header = "#{@game.current_player().name()}\'s Turn"
  erb(:game)
end

post('/:id/result') do
  @header = "Result"
  @game = GoFishGame.find(params.fetch('id').to_i())
  last_current_player = @game.current_player()
  target_card = Card.new({:suit => "Spades", :value => params.fetch('player-card')})
  target_player = @game.players()[params.fetch('target-player').to_i()]
  target_player_last_hand = target_player.hand().cards().length()
  @game.turn(target_player, target_card)
  target_player_current_hand = target_player.hand().cards().length()
  current_player = @game.current_player()
  if current_player == last_current_player
    @message = "You retrieved #{target_player_last_hand - target_player_current_hand} cards with the value #{target_card.value()} from #{target_player.name()}. Click continue to resume your turn."
  else
    @message = "No card with the value #{target_card.value().capitalize()} was found. It is now #{current_player.name()}\'s turn."
  end
  @card_found
  erb(:result)
end