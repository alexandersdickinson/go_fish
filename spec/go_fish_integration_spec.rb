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
    expect(page).to(have_content("No card with the value #{values[0].capitalize()} was found. It is now Jim\'s turn."))
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
      click_button("Go Fish")
      click_link("Continue")
    end
    expect(page).to(have_content("You retrieved #{card_count} card#{"s" if card_count > 1} with the value #{match_card.value().capitalize()} from #{player2.name()}. Click continue to resume your turn."))
  end
  
  it('goes fishing, and displays the caught card when the desired card is not found') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    game = GoFishGame.all()[0]
    player1 = nil
    player2 = nil
    bad_card = nil
    card_count = 0
    loop do
      card_count = 0
      player1 = game.current_player()
      player2 = (game.players() - [player1])[0]
      bad_card = player1.hand().cards()[0]
      choose("#{bad_card.suit().downcase()}-#{bad_card.value().downcase()}-radio")
      choose("#{player2.name()}")
      click_button("Ask For Card")
      break if player1 != game.current_player()
      click_link("Continue")
    end
    click_button("Go Fish!")
    fish = player1.hand().cards()[-1]
    expect(page).to(have_content("You Caught a#{"n" if fish.value() == "8" || fish.value() == "ace"}..."))
    expect(page).to(have_css("##{fish.suit.downcase()}-#{fish.value.downcase()}"))
  end
  
  it('gives players without cards in their hand 5 cards while there are cards left in the deck') do
    visit('/')
    fill_in('player_count', :with => '3')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    fill_in('player-name2', :with => 'Larry')
    click_button('Start Game')
    game = GoFishGame.all()[0]
    target_card = nil
    target_player = game.players()[-1]
    while target_player.hand().cards().length() > 0
      if game.current_player() != target_player
        found_card = false
        game.current_player().hand().cards().each() do |card1|
          target_player.hand().cards().each() do |card2|
            if card1.value() == card2.value()
              target_card = card1
              found_card = true
              break
            end
          end
          break if found_card
        end
        if found_card
          choose("#{target_card.suit().downcase()}-#{target_card.value().downcase()}-radio")
          choose("#{target_player.name()}")
          click_button("Ask For Card")
          click_link("Continue")
        else
          card = game.current_player().hand().cards()[0]
          choose("#{card.suit().downcase()}-#{card.value().downcase()}-radio")
          choose("#{target_player.name()}")
          click_button("Ask For Card")
          click_button("Go Fish!")
          click_link("Continue")
        end
      else
        mismatch = false
        game.current_player().hand().cards().each() do |card1|
          game.players()[0].hand().cards().each() do |card2|
            if card1.value() != card2.value()
              target_card = card1
              mismatch = true
              break
            end
          end
          break if mismatch
        end
        if mismatch
          choose("#{target_card.suit().downcase()}-#{target_card.value().downcase()}-radio")
          choose("#{target_player.name()}")
          click_button("Ask For Card")
          click_button("Go Fish!")
          click_link("Continue")
        else
          card = game.current_player().hand().cards()[0]
          choose("#{card.suit().downcase()}-#{card.value().downcase()}-radio")
          choose("#{target_player.name()}")
          click_button("Ask For Card")
          click_link("Continue")
        end
      end
      while game.current_player() != target_player
        player_card = game.current_player().hand().cards()[0]
        choose("#{player_card.suit().downcase()}-#{player_card.value().downcase()}-radio")
        choose("#{target_player.name()}")
        click_button("Ask For Card")
        match = false
        target_player.hand().cards().each() do |target_card|
          if target_card.value() == player_card.value()
            match = true
            break
          end
        end
        click_button('Go Fish!') if !match
        click_link("Continue")
      end
      expect(page).to(have_content("Your cards have been replenished."))
    end
  end
  
  it('informs players when they have been eliminated from play') do
    visit('/')
    fill_in('player_count', :with => '2')
    click_button("New Game")
    fill_in('player-name0', :with => 'Ralph')
    fill_in('player-name1', :with => 'Jim')
    click_button('Start Game')
    game = GoFishGame.all()[0]
    while game.current_player() != target_player
      player_card = game.current_player().hand().cards()[0]
      choose("#{player_card.suit().downcase()}-#{player_card.value().downcase()}-radio")
      choose("#{target_player.name()}")
      click_button("Ask For Card")
      match = false
      target_player.hand().cards().each() do |target_card|
        if target_card.value() == player_card.value()
          match = true
          break
        end
      end
      click_button('Go Fish!') if !match
      click_link("Continue")
    end
  end
end