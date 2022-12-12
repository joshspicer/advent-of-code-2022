#!/usr/bin/env ruby

# Input file
FILENAME='input.txt'  # example.txt

DEBUG = false

class CPU
    attr_reader :total_signal_strength, :crt

    def initialize
        # Registers
        @X = 1
        @cycle = 0

        # Part 01
        @total_signal_strength = 0

        # Part 02
        @crt = [] # The 40 wide by 6 high screen
    end

    def run(instruction, value)
        # Start the cycle
        increment_cycle

        # Process current instruction
        case instruction
        when 'noop'
            # do nothing.
        when 'addx'
            increment_cycle # AddX consumes two cycles
            value_to_add = value.to_i
            @X += value_to_add
        end
    end

    def check_emit_signal
        # If the sprite is positioned such that one of its three 
        # pixels is the pixel currently being drawn, the screen produces a 
        # lit pixel (#); otherwise, the screen leaves the pixel dark (.).

        sprite = [(@cycle - 1) % 40, (@cycle) % 40, (@cycle + 1) % 40]

        if @cycle % 40 == 0
            puts # New line
        end

        if sprite.include?(@X % 40)
            @crt << '#'
        else
            @crt << '.'
        end

    end

    def increment_cycle
        check_emit_signal
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

puts "Part 01:  #{cpu.total_signal_strength}";puts

# Print the CRT, breaking it into 6 lines
puts "Part 02:";puts

for idx in 0..(40 * 6)
    if (idx % 40) == 0
        puts # New line
    end

    print cpu.crt[idx]
    # puts idx
end

