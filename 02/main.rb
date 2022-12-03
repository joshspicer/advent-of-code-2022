#!/usr/bin/env ruby


PLAY_ROCK_SCORE = 1
PLAY_PAPER_SCORE = 2
PLAY_SCISSORS_SCORE = 3

OUTCOME_LOST = 0
OUTCOME_DRAW = 3
OUTCOME_WON = 6

OPPONENT_ROCK = "A"
OPPONENT_PAPER = "B"
OPPONENT_SCISSORS = "C"

# PART 1
MY_ROCK = "X"
MY_PAPER = "Y"
MY_SCISSORS = "Z"

# PART 2
NEEDS_TO_LOSE = "X"
NEEDS_TO_DRAW = "Y"
NEEDS_TO_WIN = "Z"

class Move
    attr_reader :opponent_move
    attr_reader :my_suggested_move

    def initialize(opponent_move, my_suggested_move)
        @opponent_move = opponent_move
        @my_suggested_move = my_suggested_move
    end

    def pretty_print
        puts "Your opponent played #{@opponent_move}"
        puts "You should play #{@my_suggested_move}"
        puts "Score (part 1): #{outcome}"
        puts "Score (part 2): #{outcome_part_2}"
    end



    def outcome
        # Draw
        if opponent_move == map_to_opponent_move(my_suggested_move)
            return OUTCOME_DRAW + points_for_playing_a_specific_hand
        end

        if opponent_move == OPPONENT_ROCK
            if my_suggested_move == MY_PAPER
                return OUTCOME_WON + points_for_playing_a_specific_hand
            else
                return OUTCOME_LOST + points_for_playing_a_specific_hand
            end
        end

        if opponent_move == OPPONENT_PAPER
            if my_suggested_move == MY_SCISSORS
                return OUTCOME_WON + points_for_playing_a_specific_hand
            else
                return OUTCOME_LOST + points_for_playing_a_specific_hand
            end
        end

        if opponent_move == OPPONENT_SCISSORS
            if my_suggested_move == MY_ROCK
                return OUTCOME_WON + points_for_playing_a_specific_hand
            else
                return OUTCOME_LOST + points_for_playing_a_specific_hand
            end
        end
    end

    def outcome_part_2
        # Draw
        if my_suggested_move == NEEDS_TO_DRAW
            if opponent_move == OPPONENT_ROCK
                return OUTCOME_DRAW + PLAY_ROCK_SCORE
            elsif opponent_move == OPPONENT_PAPER
                return OUTCOME_DRAW + PLAY_PAPER_SCORE
            elsif opponent_move == OPPONENT_SCISSORS
                return OUTCOME_DRAW + PLAY_SCISSORS_SCORE
            end
        end

        # Lose
        if my_suggested_move == NEEDS_TO_LOSE
            if opponent_move == OPPONENT_ROCK
                return OUTCOME_LOST + PLAY_SCISSORS_SCORE
            elsif opponent_move == OPPONENT_PAPER
                return OUTCOME_LOST + PLAY_ROCK_SCORE
            elsif opponent_move == OPPONENT_SCISSORS
                return OUTCOME_LOST + PLAY_PAPER_SCORE
            end
        end

        # Win
        if my_suggested_move == NEEDS_TO_WIN
            if opponent_move == OPPONENT_ROCK
                return OUTCOME_WON + PLAY_PAPER_SCORE
            elsif opponent_move == OPPONENT_PAPER
                return OUTCOME_WON + PLAY_SCISSORS_SCORE
            elsif opponent_move == OPPONENT_SCISSORS
                return OUTCOME_WON + PLAY_ROCK_SCORE
            end
        end
    end

private
    # ...shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) ....
    def points_for_playing_a_specific_hand
        if my_suggested_move == MY_ROCK
            return PLAY_ROCK_SCORE
        elsif my_suggested_move == MY_PAPER
            return PLAY_PAPER_SCORE
        elsif my_suggested_move == MY_SCISSORS
            return PLAY_SCISSORS_SCORE
        end
    end

    def map_to_opponent_move(my_suggested_move)
        if my_suggested_move == MY_ROCK
            return OPPONENT_ROCK
        elsif my_suggested_move == MY_PAPER
            return OPPONENT_PAPER
        elsif my_suggested_move == MY_SCISSORS
            return OPPONENT_SCISSORS
        end
    end
end

input_file = File.new("input.txt", "r") # example.txt
moves = Array.new

for line in input_file
    parsed = line.split(" ")
    moves << Move.new(parsed[0], parsed[1])
end

for m in moves
    m.pretty_print
end

# Sum all the moves
puts "Part 01:"
puts moves.reduce(0) { |sum, move| sum + move.outcome }

puts "Part 02:"
puts moves.reduce(0) { |sum, move| sum + move.outcome_part_2 }