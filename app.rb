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
  @header = "#{@game.current_player().name()}\'s Turn"
  erb(:game)
end

post('/:id') do
  @game = GoFishGame.find(params.fetch('id').to_i())
  @header = "#{@game.current_player().name()}\'s Turn"
  erb(:game)
end