#!/usr/bin/env ruby

# Input file
FILENAME='input.txt' # example.txt
# Hardcode number of stacks to avoid parsing that information out.
NUMBER_OF_STACKS = 9

class Shipyard
    def initialize
        # x   x   x
        # x   x   x
        # ---------
        # 1   2   3
        @stack = []

        for i in 0..NUMBER_OF_STACKS
            @stack.append(Array.new)
        end
    end

    def add_ship(container, idx)
        @stack[idx].push(container)
    end

    def pretty_print
        puts '-----------------'
        for i in 0..NUMBER_OF_STACKS
            curr = @stack[i]

            for j in 0..curr.length
                puts curr[j]
            end
        end
        puts '-----------------'
    end

    def move_ship(number_to_move, from, to)
        puts "move #{number_to_move} from idx=#{from} to idx=#{to}"

        for i in 1..number_to_move.to_i
            popped = @stack[from].delete_at(0)
            puts "popped #{popped} from idx=#{from}"
            @stack[to].unshift(popped)
        end
    end

    def get_top_of_stacks
        for i in 0..NUMBER_OF_STACKS
            print @stack[i].first
        end
        puts
    end
end

shipyard = Shipyard.new

start_of_rules = 0
# Parse the shipyard
File.readlines(FILENAME).each_with_index  do  |line, i|
    if line.match(/^ 1   2 /)
       start_of_rules = i
       break
    end

    for j in 0..NUMBER_OF_STACKS
        left = j*4
        right  = left + 2
        target = line[left..right]
        if target.match(/\[(.*)\]/)
            container = target.match(/\[(.*)\]/)[1]
            # puts "#{i}:  match at index #{j}  -> #{container}"
            shipyard.add_ship(container, j)
        end
    end
end

# shipyard.pretty_print

# Parse the rules
File.readlines(FILENAME).each_with_index  do  |line, i|
    if i <= start_of_rules + 1
        next
    end

    # move 2 from 4 to 2
    parsed = line.match(/move (.*) from (.*) to (.*)/)

    number_to_move = parsed[1]
    from = parsed[2].to_i - 1
    to = parsed[3].to_i - 1

    shipyard.move_ship(number_to_move, from, to)
end

# shipyard.pretty_print

shipyard.get_top_of_stacks