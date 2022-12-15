#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'
require 'rgl/path'
require 'rgl/implicit'

# Input file
FILENAME='example.txt'  # example.txt
input_file = File.new(FILENAME, "r")

DEBUG = true

def should_add_edge?(from, to)
    # Remove the coordinates from the node name

    # If from or to don't match the pattern, skip
    return false if from !~ /[a-z]_\d+_\d+/ && from !~/S/ && to !~ /[a-z]_\d+_\d+/ && to !~/E/
    
    from = from.split('_')[0]
    to = to.split('_')[0]

    from = 'a' if from == 'S'
    to = 'a' if to == 'S'

    from = 'z' if from == 'E'
    to = 'z' if to == 'E'

    if (from < 'a' || from > 'z') || (to < 'a' || to > 'z')
        raise "Invalid letter: from=#{from}  to=#{to}"
    end

    # If the letter is lower in the alphabet, or at most one letter higher, add the edge

    # puts "    Comparing #{from} (#{from.ord}) to #{to} (#{to.ord}), result = #{(from.ord - to.ord).abs}"

    return (from.ord - to.ord) <= 1
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
graph = RGL::AdjacencyGraph.new
edge_weights_map = {}
for i in 0..matrix.length-1
    for j in 0..matrix[i].length-1

        # # Inspect a single node
        # if i != 39 || j != 28
        #     next
        # end

        current = matrix[i][j]
        neighbors = get_neighbors(matrix, i, j)

        # puts "Neighbors of #{current}:"
        # puts neighbors

        neighbors.each do |n|

            if should_add_edge?(current, n)
                graph.add_edge(current, n)
                edge_weights_map[[current, n]] = 1
            end
            # if should_add_directed_edge?(n, current)
            #     graph.add_edge(n, current)
            #     edge_weights_map[[n, current]] = 1
            # end
        end
    end
end

puts "Finished generating graph";puts

puts graph.write_to_graphic_file('jpg') if DEBUG

# Check that every single vertex has been added
# for i in 0..(41-1)
#     for j in 0..(70-1)
#         xxxx = input_line[i][j]
#         vertex = "#{xxxx}_#{i}_#{j}"
#         if graph.vertices.find { |v| v == vertex } == nil
#             puts "Vertex #{vertex} not found"
#         end
#     end
# end

# if DEBUG
    # # Get the edges of the S vertex
    # puts "Edges of S:"
    # puts graph.edges_filtered_by { |u,v| u == 'S' || v == 'S' }

    # puts "Edges of a_19_0:"
    # puts graph.edges_filtered_by { |u,v| u == 'a_19_0' || v == 'a_19_0' }

    # puts "Final vertex"
    # puts graph.vertices.last

    # puts "Get vertex i_40_70"
    # puts graph.vertices.find { |v| v == 'a_40_70' }

    # puts "count of vertices"
    # puts graph.vertices.count
    
    # # Get the edges of the E vertex
    # puts "Edges of E:"
    # puts graph.edges_filtered_by { |u,v| v == 'E' || u == 'E' }
# end 

# DEBUG
# target_elevation = 'c'
# target_x = 40
# target_y = 15
# END_CELL = "#{target_elevation}_#{target_x}_#{target_y}"

# if graph.path?('S', END_CELL)
#     puts "Path exists";puts
# else
#     raise"Path does not exist"
# end

# Find the shortest path with Dijkstra's algorithm from S to E
shortest_path = graph.dijkstra_shortest_path(edge_weights_map, 'S', 'E')

puts "Path:";puts
puts shortest_path

# puts "Get a vertex:"
# puts graph.vertices.find { |v| v == "b_40_1" }

# puts
# puts "Get adjacency list for target (#{END_CELL}):"
# puts graph.adjacent_vertices(END_CELL)
# puts


# puts "Get neighbors of target (#{target_x}, #{target_y}):"
# targets_neighbors = get_neighbors(matrix, target_x, target_y)
# targets_neighbors.each do |n|
#     print n
#     if should_add_edge?(n, END_CELL)
#         puts " ✅"
#     else
#         puts;
#     end
# end

# puts;

puts "Part 01:"
puts "#{shortest_path.length-1} steps"