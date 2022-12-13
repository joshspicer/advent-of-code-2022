#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'
require 'rgl/path'

# Input file
FILENAME='example.txt'  # example.txt
input_file = File.new(FILENAME, "r")

DEBUG = true

def should_add_directed_edge?(from, to)
    # Remove the coordinates from the node name

    # If from or to don't match the pattern, skip
    return false if from !~ /[a-z]_\d+_\d+/ && from !~/S/ && to !~ /[a-z]_\d+_\d+/ && to !~/E/

    from = from.split('_')[0]
    to = to.split('_')[0]

    from = 'a' if from == 'S'
    # to = 'a' if to == 'S'

    # from = 'z' if from == 'E'
    to = 'z' if to == 'E'

    # If the letter is lower in the alphabet, or at most one letter higher, add the edge
    return (from.ord - to.ord).abs <= 1
end

def get_neighbors(matrix, i, j)
    neighbors = []

    if i > 0
        neighbors << matrix[i-1][j]
    end
    if i < matrix.length-1
        neighbors << matrix[i+1][j]
    end
    if j > 0
        neighbors << matrix[i][j-1]
    end
    if j < matrix[i].length-1
        neighbors << matrix[i][j+1]
    end

    return neighbors
end

input_line = []
input_file.each_line do |line|
    input_line << line
end

# Read into a 2D matrix (making each node uniquely named)
matrix = []
for i in 0..input_line.length-1
    matrix[i] = []
    for j in 0..input_line[i].length-1
        if input_line[i][j] == 'S' || input_line[i][j] == 'E'
            matrix[i][j] = input_line[i][j]
        else
         matrix[i][j] = "#{input_line[i][j]}_#{i}_#{j}"
        end
    end
end

# Convert the input file to an rgl adjacency graph
graph = RGL::DirectedAdjacencyGraph.new
edge_weights_map = {}
for i in 0..matrix.length-1
    for j in 0..matrix[i].length-1
        current = matrix[i][j]
        neighbors = get_neighbors(matrix, i, j)

        neighbors.each do |n|
            if should_add_directed_edge?(current, n)
                graph.add_edge(current, n)
                edge_weights_map[[current, n]] = 1
            end
        end
    end
end
puts "Finished generating graph";puts

puts graph.write_to_graphic_file('jpg') if DEBUG

if graph.path?('S', 'E')
    puts "Path exists";puts
else
    raise"Path does not exist"
end

# Find the shortest path with Dijkstra's algorithm from S to E
shortest_path = graph.dijkstra_shortest_path(edge_weights_map, 'S', 'E')


puts "Part 01:"
puts "#{shortest_path.length-1} steps"