#!/usr/bin/env ruby

require "set"

class Rucksack
    
  attr_reader :rucksack

  def initialize
    @left_compartment = Set.new
    @right_compartment = Set.new
    @rucksack = Set.new
    @intersection = ''
    @score = 0
  end

  def parse(input)
    size = input.length - 1  # -1 because of the newline
    if size % 2 != 0
        raise "Invalid input - #{input}"
    end
    
    @left_compartment = input[0..size/2 - 1].split('')
    @right_compartment = input[size/2..size - 1].split('')

    @rucksack = @left_compartment + @right_compartment
  end

  def pretty_print
    puts "Rucksack: #{@rucksack}"
    puts "Left compartment: #{@left_compartment}"
    puts "Right compartment: #{@right_compartment}"
    puts "Intersection: #{@intersection}"
    puts "Score: #{@score}"
  end

  def find_intersection
    intersect = (@left_compartment.intersection(@right_compartment)).to_a
    if intersect.empty? || intersect.length > 1
        raise "Invalid input - #{@intersection}"
    end
    @intersection = intersect[0]
  end

  def calcuate_score
    # Ordinal value of string 'a' is 97
    # Ordinal value of string 'A' is 65

    if @intersection =~ /[a-z]/
        @score = @intersection.ord - 96
    elsif @intersection =~ /[A-Z]/
        @score = (@intersection.ord - 64) + 26
    else
        raise "Invalid input - #{@intersection}"
    end
  end

  def solve
    find_intersection
    calcuate_score
    # pretty_print
    return @score
  end
end

input_file = File.new("input.txt", "r") # example.txt

rucksacks = []

for line in input_file
    r = Rucksack.new
    r.parse(line)
    rucksacks << r
end

score = 0
for r in rucksacks
    score = score + r.solve
end

puts "Part one score: #{score}"

# Group rucksacks into groups of 3
rucksacks_by_group = rucksacks.each_slice(3).to_a

part2 = 0
for groups in rucksacks_by_group
    a = groups[0].rucksack
    b = groups[1].rucksack
    c = groups[2].rucksack

    # Find the intersection of the three rucksacks
    intersect = ((a.intersection(b)).intersection(c))[0]

    if intersect =~ /[a-z]/
        part2 = (intersect.ord - 96) + part2
    elsif intersect =~ /[A-Z]/
        part2 = ((intersect.ord - 64) + 26) + part2
    else
        raise "Invalid input - #{intersect}"
    end
end

puts "Part two score: #{part2}"