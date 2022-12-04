#!/usr/bin/env ruby

require "set"

class Pair
    def initialize(input)
        @raw = input

        split = input.split(',')

        first_elf        =  split[0].split('-')
        @first_elf_start = first_elf[0].to_i
        @first_elf_end   = first_elf[1].to_i

        second_elf        =  split[1].split('-')
        @second_elf_start =  second_elf[0].to_i
        @second_elf_end   =  second_elf[1].to_i
    end

    def pretty_print
        puts "First elf: #{@first_elf_start} - #{@first_elf_end}"
        puts "Second elf: #{@second_elf_start} - #{@second_elf_end}"
    end

    def fully_contains?
        first_range = (@first_elf_start..@first_elf_end)
        second_range = (@second_elf_start..@second_elf_end)

        first_range.cover?(second_range) || second_range.cover?(first_range)
    end

    def overlap_at_all?
        first_set = Set.new (@first_elf_start..@first_elf_end)
        second_set = Set.new (@second_elf_start..@second_elf_end)

        !(first_set & second_set).empty?

        # or more efficiently:
        # @first_elf_start <= @second_elf_end && @second_elf_start <= @first_elf_end 
    end

end

input_file = File.new("input.txt", "r") # example.txt

pairs = []

# Parse
for line in input_file
    pairs.append(Pair.new(line))
end

# Part 1
fully_covered = 0
for p in pairs
    fully_covered += 1 if p.fully_contains?
end
puts "Fully covered: #{fully_covered}"


# Part 2
overlap_at_all = 0
for p in pairs
    overlap_at_all += 1 if p.overlap_at_all?
end
puts "Overlap at all: #{overlap_at_all}"