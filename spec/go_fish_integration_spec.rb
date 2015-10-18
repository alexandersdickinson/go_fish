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
    expect(page).to(have_content("Game 1"))
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
  it("it initially displays the player\'s cards face-down") do
    
  end
  
  it("allows the player to flip their cards over") do
  end
  
  it('allows players to target one other player') do
  end
  
  it('allows players to select a card in their hand to ask the target player for') do
  end
  
  it('displays the books in posession of the player') do
  end
  
  it('displays appropriate information on the other players') do
  end
end