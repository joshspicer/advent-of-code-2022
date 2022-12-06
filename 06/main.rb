#!/usr/bin/env ruby

# Input file
FILENAME='input.txt' # example.txt

input_file = File.new(FILENAME, "r") # example.txt

def parse(line)
    buffer = Array.new(4)
    

end

for line in input_file
  puts parse(line)
end