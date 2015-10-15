require('card')

class Hand
  attr_reader(:hand)
  
  def initialize()
    @hand = []
  end
  
  def add(card)
    @hand.push(card)
  end
  
  def remove(card)
    @hand.delete(card)
  end
end