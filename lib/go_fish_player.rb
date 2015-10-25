class GoFishPlayer
  attr_reader(:books, :hand, :name)
  
  def initialize(hand)
    @hand = hand
    @books = 0
  end
  
  def add_to_books()
    # @hand.cards().each() do |card1|
#       counter = 0
#       value = card1.value()
#       @hand.cards().each() do |card2|
#         counter += 1 if card1.value() == card2.value()
#       end
#       if counter == 4
#         @hand.cards().each() do |remove_card|
#           @hand.cards().delete(remove_card) if value == remove_card.value()
#         end
#         @books += 1
#       end
#     end
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