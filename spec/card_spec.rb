require('rspec')
require('card')

describe(Card) do
  @@create_card = lambda do |key, value|
    attributes = {:value => nil, :suit => nil}
    attributes.merge!({key => value})
    Card.new(attributes)
  end
  
  describe('#value') do
    it("returns the value of the card") do
      test_value = "King"
      expect(@@create_card.call(:value, test_value).value()).to(eq(test_value))
    end
  end
  
  describe('#suit') do
    it("returns the suit of the card") do
      test_suit = "Diamonds"
      expect(@@create_card.call(:suit, test_suit).suit()).to(eq(test_suit))
    end
  end
end