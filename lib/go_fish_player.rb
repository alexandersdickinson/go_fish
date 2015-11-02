class GoFishPlayer
  attr_reader(:books, :hand, :name)
  
  def initialize(hand)
    @hand = hand
    @books = 0
  end
  
  def add_to_books()
    values = @hand.cards().map() { |card| card.value() }
    values.uniq!()
    values.each() do |value|
      count = @hand.cards().count() { |card| card.value() == value }
      if count == 4
        @hand.cards().delete_if() { |card| card.value() == value }
        @books += 1
      end
    end
  end
  
  def name=(name)
    @name = name
  end
end