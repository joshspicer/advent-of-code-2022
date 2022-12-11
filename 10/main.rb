#!/usr/bin/env ruby

# Input file
FILENAME='example_large.txt'  # example.txt

class Instruction
    attr_reader :type, :value

    # Internal representation of a 'no-op' during 
    # 'end_cycle' instruction application.
    # Not to be confused with a 'noop' instruction
    def self.create_skip
        return Instruction.new('SKIP_SENTINEL', nil)
    end

    def initialize(type, value)
        @type = type
        @value = value
    end
end

class CPU
    attr_reader :X, :cycle

    def initialize
        # Registers
        @X = 1
        @cycle = 0

        @buffered_instructions = [] # Queue
    end

    def run(instruction, value)
        case instruction
        when 'noop'
            # do nothing.
        when 'addx'
            instruction = Instruction.new('addx', value.to_i)
            @buffered_instructions << Instruction.create_skip << instruction
        end
    end

    def start_cycle
        @cycle += 1
    end

    def end_cycle
        if @buffered_instructions.empty?
            return
        end

        # Execute the head of the queue
        # Will automatically skip the 'SKIP_SENTINEL' instruction, used an implementation detail for addX
        instruction_to_process = @buffered_instructions.shift

        case instruction_to_process.type
        when 'addx'
            @X += instruction_to_process.value
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

    # Indicate start of the clock cycle
    cpu.start_cycle

    # Interesting cycles
    if cpu.cycle == 20 || (cpu.cycle + 20) % 40 == 0
        cpu.print_registers
    end


    cpu.run(instr, value)

    # End of clock cycle
    cpu.end_cycle
end

