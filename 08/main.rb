#!/usr/bin/env ruby

# Input file
FILENAME='input.txt'  # example.txt
input_file = File.new(FILENAME, "r")

def pretty_print_2d_array(arr)
    arr.each do |row|
        row.each do |col|
            print "#{col} "
        end
        puts
    end
end

# Iterate through string into 2d array
forest = []
input_file.each_line do |line|
    forest << line.chomp.split('').map(&:to_i)
end

pretty_print_2d_array(forest)
puts;puts;

max_value_each_row = {}
max_value_each_column = {}

part01 = 0
for i in 0..forest.length-1
    for j in 0..forest[i].length-1
        current_value = forest[i][j]

        is_visible = false

        # If on the sides, it's always visible
        if i == 0 || i == forest.length-1 || j == 0 || j == forest[i].length-1
            is_visible = true
        else
            # Check if this tree is bigger than everything to its left
            is_visible = true if current_value > forest[i].first(j).max

            # Check if this tree is bigger than everything to its right
            is_visible = true if current_value > forest[i].last(forest[i].length-j-1).max

            # Check if this tree is bigger than everything above it
            is_visible = true if current_value > forest.first(i).map { |row| row[j] }.max

            # Check if this tree is bigger than everything below it
            is_visible = true if current_value > forest.last(forest.length-i-1).map { |row| row[j] }.max
        end

        # Increment counter
        part01 += 1 if is_visible
    end
end

puts part01