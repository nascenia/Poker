class PokerLogic

  SUITS = ['C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10', 'C11', 'C12', 'C13',
           'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10', 'D11', 'D12', 'D13',
           'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'H13',
           'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10', 'S11', 'S12', 'S13']

  VALUES = (1..13).to_a

  def initialize(cards)
    @cards = cards
    @valid_cards = SUITS & cards
  end

  def valid_cards?
    @cards.length == 5 && @cards.sort  == @valid_cards.sort
  end

  def get_result

    if result = straight_flush
      return result
    elsif result = four_of_a_kind
      return result
    elsif result = full_house
      return result
    elsif result = flush
      return result
    elsif result = straight
      return result
    elsif result = three_of_a_kind
      return result
    elsif result = two_pair
      return result
    elsif result = one_pair
      return result
    else
      high_card
    end

  end

  def straight_flush
    if flush && straight
      return 'Straight flush'
    end
    return false
  end

  def four_of_a_kind
    if (x_of_a_kind(4))
      return 'Four of a kind'
    end
    return false
  end

  def full_house
    if(kind = x_of_a_kind(3))
      remaining_cards = @valid_cards - kind
      pair = x_of_a_kind(2, remaining_cards)
      if pair
        return 'Full house'
      end
    end
    return false
  end

  def flush
    types = get_card_types
    types.uniq.length == 1 ? 'Flush' : false
  end

  def straight
    values = get_values
    values.sequences.max_by(&:length).sort == values.sort ? 'Straight' : false
  end

  def three_of_a_kind
    (x_of_a_kind(3)) ? 'Three of a kind' : false
  end

  def two_pair
    if(first_pair = x_of_a_kind(2))
      remaining_cards = @valid_cards - first_pair
      second_pair = x_of_a_kind(2, remaining_cards)
      if second_pair
        return 'Two pair'
      end
    end
    return false
  end

  def one_pair
    x_of_a_kind(2) ? 'One pair' : false
  end

  def high_card
    return 'High card'
  end

  private

  # for showing high card
  def max_value
    index = 0
    max = 0
    @valid_cards.each_with_index do |c, indx|
      if card_value(c) > max
        max = card_value(c)
        index = indx
      end
    end
    return index
  end

  def x_of_a_kind(number = 2, cards = @valid_cards)
    VALUES.each do |v|
      if (ary = cards.select{|c| card_value(c) == v}).size == number
        return ary
      end
    end
    return false
  end

  def card_value(card)
    card.gsub(card[0], '').to_i
  end

  def get_values(cards = @valid_cards)
    values = []
    cards.each do |c|
      values << card_value(c)
    end
    return values
  end

  def get_card_types(cards = @valid_cards)
    types = []
    cards.each do |c|
      types << c.delete('^a-zA-Z')
    end
    return types
  end

end


