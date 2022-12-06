#!/usr/bin/env ruby

# Input file
FILENAME='input.txt' # example.txt

input_file = File.new(FILENAME, "r") # example.txt

def parse(line, count)
    queue = []
    line.split("").each do |char|
      if queue.length < count
        queue.unshift(char)
        next
      end

      if queue.length == count
        if queue & queue == queue
          pattern = queue.reverse!.join("")

          puts pattern
          idx = line.index(pattern) + count
          puts idx
          return
        end
      end

      queue.pop
      queue.unshift(char)
    end
end

for line in input_file
  puts "Part 1"
  puts "------"
  puts parse(line, 4)

  puts "Part 2"
  puts "------"
  puts parse(line, 14)
end