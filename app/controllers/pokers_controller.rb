class PokersController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: :multi_hand

  RANKS = {
      high_card: 1,
      one_pair: 2,
      two_pair: 3,
      three_of_a_kind: 4,
      straight: 5,
      flush: 6,
      full_house: 7,
      four_of_a_kind: 8,
      straight_flush: 9
  }

  def index

  end

  def single_hand
    unless params['cards']
      @error = 'Invalid input'
    else
      @cards = params['cards'].split(' ')
      poker = PokerLogic.new(@cards)
      unless poker.valid_cards?
        @error = 'Invalid Cards'
      else
        @result = poker.get_result
      end
    end
  end

  def multi_hand
    unless params[:cards]
      render json: {error: 'Parameter missing'}, status: :bad_request and return
    end
    @cards = params[:cards]
    result_map = {}
    @cards.each_with_index do |card, index|
      @hand = card.split(' ')
      poker = PokerLogic.new(@hand)
      unless poker.valid_cards?
        render json: {error: "Invalid cards at position #{(index+1).to_s}"}, status: :unprocessable_entity and return
      else
        result = poker.get_result
        result_map[index] = result
      end
    end
    render json: {result: json_result(@cards, result_map)}, status: :ok
  end

  private
  def json_result(cards, results)
    best_index = 0
    best_rank = 0
    cards.map.with_index do |card, index|
      if best_rank < RANKS[results[index].gsub(' ', '_').downcase.to_sym]
        best_rank = RANKS[results[index].gsub(' ', '_').downcase.to_sym]
        best_index = index
      end
    end
    result = cards.map.with_index do |c, index|
      {card: c, hand: results[index]}
    end
    result[best_index][:best] = true
    return result
  end

end
