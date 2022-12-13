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
    ROUNDS = 20
    DEBUG = true
elsif arg == 'input'
    # Input
    FILENAME='input.txt' 
    NUM_MONKEYS=8
    ROUNDS = 20
    DEBUG = false
else
    puts "Unknown argument: '#{arg}'"
    exit
end

class Operation
    attr_reader :operator, :operand

    def initialize(operator, operand)
        @operator = operator
        @operand = operand # Can be a number, -or- the 'old' value
    end

    def apply(old_value)
        if @operand == 'old'
            operand = old_value
        else
            operand = @operand.to_i
        end

        if @operator == '*'
            result = old_value * operand
            puts "    Worry level is multiplied by #{operand} to #{result}" if DEBUG
            return result
        elsif @operator == '+'
            result = old_value + operand
            puts "    Worry level is increases by #{operand} to #{result}" if DEBUG
            return result
        elsif
            raise "Unknown operator: #{@operator}"
        end
    end

    def pretty_print
        puts "Operation: new = old #{@operator} #{@operand}"
    end
end

class TestFunction
    attr_reader :divisible_by, :throw_to_x_if_true, :throw_to_x_if_false

    def initialize(divisible_by, throw_to_x_if_true, throw_to_x_if_false)
        @divisible_by = divisible_by
        @throw_to_x_if_true = throw_to_x_if_true
        @throw_to_x_if_false = throw_to_x_if_false
    end

    # The number of the monkey to throw to (1-indexed)
    def test(worry_level)
        if worry_level % @divisible_by.to_i == 0
            puts "    Current worry level is divisible by #{@divisible_by}." if DEBUG
            return @throw_to_x_if_true.to_i
        else
            puts "    Current worry level is not divisible by #{@divisible_by}." if DEBUG
            return @throw_to_x_if_false.to_i
        end
    end

    def pretty_print
        puts "Test: divisible by #{@divisible_by}"
        puts "If true: throw to monkey #{@throw_to_x_if_true}"
        puts "If false: throw to monkey #{@throw_to_x_if_false}"
    end
end

class Monkey
    attr_reader :operation, :test_func
    attr_accessor :items, :inspect_count

    def initialize(starting_items, operation, test_func)
        @items = starting_items # Array
        @operation = operation
        @test_func = test_func

        @inspect_count = 0
    end

    def pretty_print
        puts "Monkey:"
        puts "Starting items: #{@items.join(', ')}"
        @operation.pretty_print
        @test_func.pretty_print
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
        monkeys << Monkey.new(start_items, operation, test_function)

        # Swallow new line
        file.gets
    end
end

# Part 01
for round in 1..ROUNDS
    for monkey in monkeys
        num_items = monkey.items.length

        # if DEBUG
        #     puts "~~~~~~"
        #     for i in 0..NUM_MONKEYS-1
        #         puts "Monkey #{i + 1}: #{monkeys[i].items.join(', ')}"
        #     end
        #     puts "~~~~~~"
        # end

        puts "Monkey #{monkeys.index(monkey)}" if DEBUG

        for i in 1..num_items
            # Pop first item from monkey's list
            item = monkey.items.shift
            puts "  Monkey inspects an item with a worry level of #{item}" if DEBUG

            monkey.inspect_count += 1

            # Apply operation
            worry_level = monkey.operation.apply(item)

            # Divide by 3 and floor
            worry_level = worry_level / 3
            puts "    Monkey gets bored with item. Worry level is divided by 3 to #{worry_level}" if DEBUG

            # Test worry level
            throw_to_monkey_number = monkey.test_func.test(worry_level)
            puts "    Item with worry level #{worry_level} is thrown to monkey #{throw_to_monkey_number}." if DEBUG

            # Throw to monkey
            monkeys[throw_to_monkey_number].items << worry_level
        end
    end
end

# Part 01
# Get the two monkeys with the largest inspect_count
inspect_counts = monkeys.map { |monkey| monkey.inspect_count }
inspect_counts.sort!
inspect_counts.reverse!
puts "Part 01: #{inspect_counts[0] * inspect_counts[1]}"