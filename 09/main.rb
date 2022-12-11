#!/usr/bin/env ruby

require 'set'

# Input file
FILENAME='input.txt'  # example.txt

class Knot
    attr_accessor :x, :y
    attr_reader :path

    def initialize
        @x = 0
        @y = 0

        @path = Set.new
        update_path
    end

    def move_right
        @x += 1
    end

    def move_left
        @x -= 1
    end

    def move_up
        @y += 1
    end

    def move_down
        @y -= 1
    end

    # --- Move Diagonally

    def move_up_left
        move_up
        move_left
    end

    def move_up_right
        move_up
        move_right
    end

    def move_down_left
        move_down
        move_left
    end

    def move_down_right
        move_down
        move_right
    end

    # --- Helpers

    def pretty_print
        return "#{@x}, #{@y}"
    end

    def update_path
        @path.add([@x, @y])
    end
end

# The head and tail must always be touching
# (Diagonally or overlapping count!)
def update_tail(head, tail)
    same_row_or_column = (head.x == tail.x || head.y == tail.y)


    # If the head is ever two steps directly up, down, left, or right from the tail, 
    # the tail must also move one step in that direction so it remains close enough.
    if ((head.x - tail.x).abs == 2 || (head.y - tail.y).abs == 2) && same_row_or_column
        if head.x > tail.x
            tail.move_right
        elsif head.x < tail.x
            tail.move_left
        elsif head.y > tail.y
            tail.move_up
        elsif head.y < tail.y
            tail.move_down
        end

        # Done
        tail.update_path
        return
    end

    # Otherwise, if the head and tail aren't touching and 
    # aren't in the same row or column, the tail always moves 
    # one step diagonally to keep up:

    # The head and tail are touching (left right up or down)
    touching = (head.x - tail.x).abs + (head.y - tail.y).abs == 1

    # The head and tail are touching diagonally
    touching_diagnonally = (head.x - tail.x).abs == 1 && (head.y - tail.y).abs == 1

    # If they are not in the same row or column

    # Move one step diagonally to catch up
    if !touching && !touching_diagnonally
        if head.x > tail.x
            if head.y > tail.y
                tail.move_up_right
            elsif head.y < tail.y
                tail.move_down_right
            end
        elsif head.x < tail.x
            if head.y > tail.y
                tail.move_up_left
            elsif head.y < tail.y
                tail.move_down_left
            end
        end
    end

    tail.update_path
end

# Create the two knots.
head = Knot.new
tail = Knot.new

input_file = File.new(FILENAME, "r")

input_file.each_line do |line|

    instru = line.split(' ')
    direction = instru[0]
    count     = instru[1].to_i

    for i in 1..count
        case direction
        when 'R'
            head.move_right
        when 'L'
            head.move_left
        when 'U'
            head.move_up
        when 'D' 
            head.move_down
        end

        update_tail(head, tail)  # Corrects the location of the tail

        # puts "#{direction}: Head moved to   #{head.pretty_print}"
        # puts "#{direction}: Tail is at   #{tail.pretty_print}"
    end
end

# Part 1
# See how many distinct locations the the tails knot has visited
puts "Part 1: #{tail.path.size}";puts
# puts tail.path

# ----------------------------------------------

# Part 2
# [Head(0), Tail(1), ... Tail(N), ... Tail(9)]
knots = Array.new(10) { Knot.new }
head = knots[0]

input_file = File.new(FILENAME, "r")
input_file.each_line do |line|
    
    instru = line.split(' ')
    direction = instru[0]
    count     = instru[1].to_i

    for i in 1..count
        case direction
        when 'R'
            head.move_right
        when 'L'
            head.move_left
        when 'U'
            head.move_up
        when 'D' 
            head.move_down
        end

        # Update the tails with the location of the previous knot
        for i in 1..knots.size-1
            update_tail(knots[i-1], knots[i])
        end
    end
end

puts "Part 2: #{knots[9].path.size}";puts