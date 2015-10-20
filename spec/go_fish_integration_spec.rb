require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('the game creation path', :type => :feature) do
  before() do
    GoFishGame.clear()
  end
  
  it('adds a game to the list of available games') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    click_link("Back")
    expect(page).to(have_content("Ralph and Jim's Game"))
  end
  
  it('allows the user to name every player in the game') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    expect(page).to(have_content("Player 1 Name"))
    expect(page).to(have_content("Player 2 Name"))
  end
  
  it('starts the game') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    expect(page).to(have_content("Ralph\'s Turn"))
  end
end

describe('the turn path', :type => :feature) do
  before() do
    GoFishGame.clear()
  end
  
  it("displays the player\'s hand") do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    game = GoFishGame.all()[0]
    game.current_player().hand().cards().each() do |card|
      suit = card.suit()
      value = card.value()
      expect(page).to(have_css("##{suit.downcase()}-#{value.downcase()}"))
    end
  end
  
  it('allows players to target one other player') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    expect(page).to(have_content("Jim"))
    expect(page).to(have_content("Ask For Card"))
  end
  
  it('displays the books in posession of all players') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    expect(page).to(have_content("Your books: 0"))
    expect(page).to(have_content("Books: 0"))
  end
  
  it('informs the player when they card they were looking for is not found') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    bad_card = nil
    game = GoFishGame.all()[0]
    player1_values = []
    player2_values = []
    values = []
    player1 = game.players()[0]
    player2 = game.players()[1]
    match_card = nil
    loop do
      player1_values = []
      player1.hand().cards().each() do |card|
        player1_values.push(card.value())
      end
      player1_values.uniq!()
      player2_values = []
      player2.hand().cards().each() do |card|
        player2_values.push(card.value())
      end
      player2_values.uniq!()
      values = player1_values - player2_values
      break if values != []
      matches = player1_values + player2_values
      matches.uniq!
      match_card = nil
      player1.hand().cards().each() do |card|
        if matches[0] == card.value()
          match_card = card
          break
        end
      end
      choose("#{match_card.suit().downcase()}-#{match_card.value().downcase()}-radio")
      choose("#{player2.name()}")
      click_button("Ask For Card")
      click_button("Continue")
    end
    player1.hand().cards().each() do |card|
      if values[0] == card.value()
        match_card = card
        break
      end
    end
    choose("#{match_card.suit().downcase()}-#{match_card.value().downcase()}-radio")
    choose("#{player2.name()}")
    click_button("Ask For Card")
    expect(page).to(have_content("No card with the value #{values[0]} was found. It is now Jim\'s turn."))
  end
  
  it('informs the player when they have retrieved the desired card') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    game = GoFishGame.all()[0]
    player1 = nil
    player2 = nil
    match_card = nil
    card_count = 0
    loop do
      card_count = 0
      player1 = game.current_player()
      player2 = (game.players() - [player1])[0]
      match_card = player1.hand().cards()[0]
      choose("#{match_card.suit().downcase()}-#{match_card.value().downcase()}-radio")
      choose("#{player2.name()}")
      player2.hand.cards().each() do |card|
        card_count = card_count + 1 if match_card.value() == card.value()
      end
      click_button("Ask For Card")
      break if player1 == game.current_player()
      click_link("Continue")
    end
    expect(page).to(have_content("You retrieved #{card_count} card#{"s" if card_count > 1} with the value #{match_card.value()} from #{player2.name()}. Click continue to resume your turn."))
  end
end