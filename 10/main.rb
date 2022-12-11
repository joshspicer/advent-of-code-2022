#!/usr/bin/env ruby

# Input file
FILENAME='input.txt'  # example.txt

DEBUG = false

class CPU
    attr_reader :total_signal_strength

    def initialize
        # Registers
        @X = 1
        @cycle = 0

        # Part 01
        @total_signal_strength = 0
    end

    def run(instruction, value)
        # Start the cycle
        increment_cycle

        # Process current instruction
        case instruction
        when 'noop'
            # do nothing.
        when 'addx'
            value_to_add = value.to_i
            increment_cycle
            @X += value_to_add
        end
    end

    def increment_cycle
        @cycle += 1
        record_signal_strength_if_interesting_cycle
    end

    def record_signal_strength_if_interesting_cycle
        # Print interesting cycles
        if @cycle == 20 || (@cycle + 20) % 40 == 0
            print_registers if DEBUG

            # Record signal strength
            @total_signal_strength += (@cycle * @X)

        end
    end

    def print_registers
        puts "Cycle:  #{@cycle}"
        puts "X:      #{@X}";puts
    end
end

# Part 01
cpu = CPU.new
input_file = File.new(FILENAME, "r")
input_file.each_line do |line|

    # -- Parse current instruction from file
    split = line.split(' ')

    instr = split[0]
    value = nil

    if split.length == 2
        value = split[1]
    end

    # -- Execute instruction
    cpu.run(instr, value)
end
puts "Part 01:  #{cpu.total_signal_strength}"