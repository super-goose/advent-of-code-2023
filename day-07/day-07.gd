extends Node2D

@export_file("*.txt") var input_file
var total = 0
enum HandType {
	FIVE_OF_A_KIND,
	FOUR_OF_A_KIND,
	FULL_HOUSE,
	THREE_OF_A_KIND,
	TWO_PAIR,
	ONE_PAIR,
	HIGH_CARD,
}

# Low to High
const HAND_RANKING = [
	HandType.HIGH_CARD,
	HandType.ONE_PAIR,
	HandType.TWO_PAIR,
	HandType.THREE_OF_A_KIND,
	HandType.FULL_HOUSE,
	HandType.FOUR_OF_A_KIND,
	HandType.FIVE_OF_A_KIND,
]

# Low to High
const CARD_RANKING = [ '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' ]
const CARD_RANKING_2 = [ 'J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A' ]

class Hand:
	var hand: String
	var bid: int
	var type: HandType

	func _init(_hand: String, _bid: int):
		hand = _hand
		bid = _bid
		type = determine_hand_type_2()

	func determine_hand_type():
		var hand_dict = Array(hand.split('')).reduce(
			func r(acc, cur):
				if cur not in acc:
					acc[cur] = 0
				acc[cur] = acc[cur] + 1
				return acc,
			{}
		)

		var size = hand_dict.size()
		if size == 1:
			return HandType.FIVE_OF_A_KIND
		elif size == 5:
			return HandType.HIGH_CARD

		var counts = hand_dict.values()
		if counts.find(4) > -1:
			return HandType.FOUR_OF_A_KIND
		elif counts.find(3) > -1:
			if counts.find(2) > -1:
				return HandType.FULL_HOUSE
			else:
				return HandType.THREE_OF_A_KIND

		var pairs = counts.filter(func f(c): return c == 2).size()
		if pairs == 2:
			return HandType.TWO_PAIR
		elif pairs == 1:
			return HandType.ONE_PAIR

	func determine_hand_type_2():
		var hand_dict = Array(hand.split('')).reduce(
			func r(acc, cur):
				if cur not in acc:
					acc[cur] = 0
				acc[cur] = acc[cur] + 1
				return acc,
			{}
		)

		var size = hand_dict.size()
		if size == 1:
			return HandType.FIVE_OF_A_KIND
		elif size == 5:
			if 'J' in hand_dict:
				return HandType.ONE_PAIR
			else:
				return HandType.HIGH_CARD

		var counts = hand_dict.values()
		if counts.find(4) > -1:
			if 'J' in hand_dict:
				return HandType.FIVE_OF_A_KIND
			else:
				return HandType.FOUR_OF_A_KIND
	
		elif counts.find(3) > -1:
			if counts.find(2) > -1:
				if 'J' in hand_dict:
					return HandType.FIVE_OF_A_KIND
				else:
					return HandType.FULL_HOUSE
			else:
				if 'J' in hand_dict:
					return HandType.FOUR_OF_A_KIND
				else:
					return HandType.THREE_OF_A_KIND

		var pairs = counts.filter(func f(c): return c == 2).size()
		if pairs == 2:
			if 'J' in hand_dict:
				if hand_dict['J'] == 2:
					return HandType.FOUR_OF_A_KIND
				else:
					return HandType.FULL_HOUSE
			else:
				return HandType.TWO_PAIR
		elif pairs == 1:
			if 'J' in hand_dict:
				return HandType.THREE_OF_A_KIND
			else:
				return HandType.ONE_PAIR

func _ready():
	var body = C_.load_file(input_file).strip_edges().split('\n')
#	var h = Hand.new('4K8J9', 69)
#	print(h.type == HandType.ONE_PAIR)
	do_the_thing(body)
	if total == 254934325 or total == 254607942:
		print('%s is not correct' % total)

func do_the_thing(body):
	var hands = Array(body).map(
		func m(line):
			var parsed = line.split(' ')
			return Hand.new(parsed[0], int(parsed[1]))
	)

	var sorted_hands = sort_hands_by_strength(hands)
	
	for i in range(sorted_hands.size()):
		total = total + ((i + 1) * sorted_hands[i].bid)
	print(total)

func sort_hands_by_strength(hands: Array):
	var sorted = []
	var type_dict = HAND_RANKING.reduce(
		func hrr(acc, cur):
			acc[cur] = []
			return acc,
		{}
	)

	for hand in hands:
		# fancy insert here?
		type_dict[hand.type].push_back(hand)
	
	for hand_type in HAND_RANKING:
		type_dict[hand_type].sort_custom(sort_by_card)
		sorted.append_array(type_dict[hand_type])

	return sorted

func sort_by_card(a, b):
	for i in range(5):
		var a_i = CARD_RANKING_2.find(a.hand[i])
		var b_i = CARD_RANKING_2.find(b.hand[i])
		if a_i < b_i:
			return true
		elif a_i > b_i:
			return false

	return true
'''
Every hand is exactly one type. From strongest to weakest, they are:

Five of a kind, where all five cards have the same label: AAAAA

Four of a kind, where four cards have the same label and one card has a different label: AA8AA

Full house, where three cards have the same label, and the remaining two cards share a different label: 23332

Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98

Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432

One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4

High card, where all cards' labels are distinct: 23456
'''
