class Card
  attr_reader(:value, :suit)
  
  def initialize(attributes)
    @value = attributes.fetch(:value)
    @suit = attributes.fetch(:suit)
  end
end