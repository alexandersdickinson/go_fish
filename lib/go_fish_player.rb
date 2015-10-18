class GoFishPlayer
  attr_reader(:books, :hand, :name)
  
  def initialize(hand)
    @hand = hand
    @books = 0
  end
  
  def add_to_books(add_card)
    @hand.cards().push(add_card)
    card_counter = 0
    @hand.cards().each() do |card|
      card_counter = card_counter + 1 if card.value() == add_card.value()
    end
    if card_counter == 4
      @hand.cards().delete_if() {|card| card.value() == add_card.value()}
      @books = @books + 1
    end
  end
  
  def name=(name)
    @name = name
  end
end