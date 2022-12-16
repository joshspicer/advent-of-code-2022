#!/usr/bin/env ruby

# Input file
FILENAME='test.txt'  # example.txt
input_file = File.new(FILENAME, "r")

DEBUG = true

require 'json'

class Packet
    attr_reader :packet_data
    def initialize(line)
        @packet_data = self.parse(line)
    end

    def parse(line)
        # parse_with_regex(line).first
        parse_with_json(line)
    end

    def parse_with_json(line)
        JSON.parse line
    end

    # [[7,[0,8,0,[10,8,10]],[1],5]]
    def parse_with_regex(line)
        container = []
        line.scan(/((\d+)|(\[\])|(\[\d\])|(\[(.+)\]))/) do |match|
            puts "---" if DEBUG
            # A Number

            puts "Match: #{match}" if DEBUG

            if match[1]
                # Match (\d+)
                puts "   Match[1]: #{match[1]}" if DEBUG
                container << match[1].to_i

            elsif match[2]
                # Match (\[\])
                # NOTE: Prevents unwrapping empty brackets
                puts "   Match[2]: #{match[2]}" if DEBUG  
                container << []

            elsif match[3]
                # Match (\[\d\])
                puts "   Match[3]: #{match[3]}" if DEBUG
                container << parse(match[3].gsub('[', '').gsub(']', ''))

            elsif match[5]
                # Match (\[(.+)\]) 
                # NOTE: unwraps the enclosing brackets
                puts "   Match[5]: #{match[5]}" if DEBUG
                container << parse(match[5])
            end

        end
        container
    end

    def pretty_print    
        print packet_data;puts
    end
end

def packets_in_order?(left, right)

    puts "* Left: #{left}    Right: #{right}"

    # If the left side runs out of items, the inputs are in the right order
    return true if left.is_a?(Array) && left.empty?
    # If the right side runs out of items, the inputs are in the wrong order
    return false if right.is_a?(Array) && right.empty?

    # If both values are integers, the lower integer should come first
    if left.is_a?(Integer) && right.is_a?(Integer)
        return left <= right

    # If both values are lists, compare each value of each list
    elsif left.is_a?(Array) && right.is_a?(Array)
        # Check that each left item is smaller 
        for i in 0..left.length
            if right[i].nil?
                break
            end

            return true if left[i].nil?
            
            puts "     Left[#{i}]: #{left[i]}    Right[#{i}]: #{right[i]}" if DEBUG
            if !packets_in_order?(left[i], right[i])
                return false
            end
        end
        # We've iterated all the left items, and this indicates there are still 
        # more items on the right side!
        puts "Checking array size : len=#{left.length} vs len=#{right.length}" if DEBUG
        return false if left.length > right.length
        
    # It must be that exactly one value is an integer and the other is a list
    # Convert the integer to a list which contains that integer as its only value, 
    # then retry the comparison
    elsif left.is_a?(Integer) && right.is_a?(Array)
        if !packets_in_order?([left], right)
            return false
        end
    elsif left.is_a?(Array) && right.is_a?(Integer)
        if !packets_in_order?(left, [right])
            return false
        end
    else
        # Catch any type errors.
        raise "ERROR: #{left} #{right}"
    end

    # Recurse on the rest
    return packets_in_order?(left[1..-1], right[1..-1])
end

# Loop over input file two lines at a time
count = 0
while (left = input_file.gets)
    right = input_file.gets

    left = Packet.new(left)
    puts " >> Left Packet: #{left.packet_data}" if DEBUG ;puts


    right = Packet.new(right)
    puts " >> Right Packet: #{right.packet_data}" if DEBUG;puts

    count += 1 if packets_in_order?(left.packet_data, right.packet_data)

    # Eat new line
    input_file.gets
end

puts;puts "Part 1:";puts count