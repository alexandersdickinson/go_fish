class Hand
  attr_reader(:cards)
  
  def initialize()
    @cards = []
  end
  
  def add(card)
    @cards.push(card)
  end
  
  def remove(card)
    @cards.delete(card)
  end
end