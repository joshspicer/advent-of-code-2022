#!/usr/bin/env ruby


if ARGV.length != 1
    puts "Usage: main.rb <example|input>"
    exit
end

arg = ARGV[0]

if arg == 'example'
    # Example
    FILENAME='example.txt' 
    NUM_MONKEYS=4
elsif arg == 'input'
    # Input
    FILENAME='input.txt' 
    NUM_MONKEYS=7
else
    puts "Unknown argument: '#{arg}'"
    exit
end

class Operation
    def initialize(operator, operand)
        @operator = operator
        @operand = operand # Can be a number, -or- the 'old' value
    end

    def pretty_print
        puts "Operation: new = old #{@operator} #{@operand}"
    end
end

class TestFunction
    def initialize(divisible_by, throw_to_x_if_true, throw_to_x_if_false)
        @divisible_by = divisible_by
        @throw_to_x_if_true = throw_to_x_if_true
        @throw_to_x_if_false = throw_to_x_if_false
    end

    def pretty_print
        puts "Test: divisible by #{@divisible_by}"
        puts "If true: throw to monkey #{@throw_to_x_if_true}"
        puts "If false: throw to monkey #{@throw_to_x_if_false}"
    end
end

class Monkey
    def initialize(starting_items, operation, test_func)
        @items = starting_items # Array
        @operation = operation
        @test = test_func
    end

    def pretty_print
        puts "Monkey:"
        puts "Starting items: #{@items.join(', ')}"
        @operation.pretty_print
        @test.pretty_print
    end
end

monkeys = []

# Parse input.
File.open(FILENAME) do |file|

    for i in 1..NUM_MONKEYS
        file.gets

        # Starting items: 79, 98
        start_items_line = file.gets
        start_items = start_items_line.scan(/\d+/).map(&:to_i)

        # Operation: new = old * 19
        operation_line = file.gets
        split = operation_line.strip.split(' ')
        operation = Operation.new(split[4], split[5])

        # Test: divisible by 23
        test_func_line = file.gets
        split = test_func_line.strip.split(' ')
        divisible_by = split[3]

        # If true: throw to monkey 2
        true_condition_line = file.gets
        split = true_condition_line.strip.split(' ')
        throw_to_x_if_true = split[5]

        # If false: throw to monkey 3
        false_condition_line = file.gets
        split = false_condition_line.strip.split(' ')
        throw_to_x_if_false = split[5]

        test_function = TestFunction.new(divisible_by, throw_to_x_if_true, throw_to_x_if_false)

        # Create Monkey
        monkey = Monkey.new(start_items, operation, test_function)
        monkeys << monkey

        # Swallow new line
        file.gets
    end
end


for monkey in monkeys
    monkey.pretty_print
    puts
end