#!/usr/bin/env ruby

class Elf
    attr_reader :value

    def initialize(value)
      @value = value
    end
  
    def total_calories
        value.reduce(0) { |i, sum| i + sum }
    end
end

input_file = File.new("input.txt", "r")
elfs = Array.new

# Parse
acc = Array.new
for line in input_file
  if line == "\n"
    elfs << Elf.new(acc)
    acc = Array.new
  else
    # Accumlate elf value
    acc.push(line.to_i)
  end
  
end

# Sort by total calories
elfs.sort_by! { |elf| elf.total_calories }.reverse!

# Print
puts elfs[0].total_calories

# Part 2
puts elfs[0].total_calories + elfs[1].total_calories + elfs[2].total_calories