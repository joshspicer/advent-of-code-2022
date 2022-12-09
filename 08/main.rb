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

puts "Part 1:"
puts part01;puts

# -------------------

highest_scenic_score = 0
optimal_tree_cooridnates = []


DEBUG = false

# Part 2
for i in 0..forest.length-1
    for j in 0..forest[i].length-1
        current_value = forest[i][j]

        # --- DEBUG: Select a single cell.
        if DEBUG
            if !(i == 3 &&  j == 2)
                next
            end
            puts "Current Value: #{current_value}";puts
        end
        # ----

       scenic_score = 1 # Default value.

        # If on the sides, scenic score is always 0, since anything multiplied by 0 is 0
        if i == 0 || i == forest.length-1 || j == 0 || j == forest[i].length-1
            # scenic_score = 0
           next
        else
            
            # Check how many trees are visible to the left
            left = forest[i].first(j).reverse!
            puts "LEFT: #{left}" if DEBUG

            left.each_with_index do |value, index|
                # We've hit a tree that is bigger than the current tree
                # If we hit the end,give the max scenic score
                if current_value <= value || index == left.length-1
                    sub_score = (index+1)
                    puts " sub_score: #{sub_score}" if DEBUG

                    scenic_score *= sub_score
                    break
                end
            end

            # Check how many trees are visible to the right
            right = forest[i].last(forest[i].length-j-1)
            puts "RIGHT: #{right}" if DEBUG

            right.each_with_index do |value, index|
                if current_value <= value || index == right.length-1
                    sub_score = (index+1)
                    puts "  sub_score: #{sub_score}" if DEBUG

                    scenic_score *= sub_score
                    break
                end
            end

            # Check how many trees are visible to below
            above = forest.first(i).map { |row| row[j] }.reverse!
            puts "ABOVE: #{above}" if DEBUG

            above.each_with_index do |value, index|
                if current_value <= value || index == above.length-1
                    sub_score = (index+1)
                    puts " sub_score: #{sub_score}" if DEBUG

                    scenic_score *= sub_score
                    break
                end
            end

            # Check how many trees are visible to below
            below = forest.last(forest.length-i-1).map { |row| row[j] }
            puts "BELOW: #{below}" if DEBUG

            below.each_with_index do |value, index|
                if current_value <= value || index == below.length-1
                    sub_score = (index+1)
                    puts " sub_score: #{sub_score}" if DEBUG

                    scenic_score *= sub_score
                    break
                end
            end
        end

        puts if DEBUG;puts "Scenic score for (#{i}, #{j}): #{scenic_score}"

        # Keep track of the best scenic score
        if scenic_score > highest_scenic_score
            highest_scenic_score = scenic_score
            optimal_tree_cooridnates = [i, j]
        end
    end
end

puts;puts "Part 2:"
puts "Score:   #{highest_scenic_score}"
puts "Coordinates:    #{optimal_tree_cooridnates}"