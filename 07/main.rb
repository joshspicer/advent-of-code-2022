#!/usr/bin/env ruby

require 'tree'  # 'gem install rubytree'

# Input file
FILENAME='input.txt' # example.txt

root_node = Tree::TreeNode.new("/", "0")

cd_command_regex = /\$ cd (.*)/
ls_command_regex = /\$ ls/

dir_regex = /dir (.*)/
file_regex = /(\d+) (.*)/

input_file = File.new(FILENAME, "r")

current_node = nil

input_file.each { |line|

  if cd_command_regex.match(line)
    captures = cd_command_regex.match(line).captures
    directory_name = captures[0]

    if directory_name == "/"
      current_node = root_node
      next
    end

    if directory_name == '..'
      parent = current_node.parent
      if parent != nil
        current_node = parent
      else
        current_node = root_node
      end
    else
      # Set current node to previously-discovered child directory
      cd_node = current_node.children.find { |child| child.name == directory_name }

      if cd_node != nil
        current_node = cd_node
      else
        puts "--------- (!) ----------"
        root_node.print_tree
        raise "Directory not found: #{directory_name}.  Current directory is #{current_node.name}"
      end
    end
  end

  if ls_command_regex.match(line)
    next
  end

  if dir_regex.match(line)
    captures = dir_regex.match(line).captures
    directory_name = captures[0]

    new_node = Tree::TreeNode.new(directory_name, "0")
    current_node << new_node
  end

  if file_regex.match(line)
    captures = file_regex.match(line).captures
    file_size = captures[0]
    file_name = captures[1]
    new_node = Tree::TreeNode.new(file_name, file_size)
    current_node << new_node
  end

}

# puts current_directory
root_node.print_tree(root_node.node_depth, nil, lambda { |node, prefix| puts "#{prefix} #{node.name} (#{node.content.to_i} bytes)" }); puts

# Part 1
# Compute the total size of each directory
part1 = 0
root_node.each { |node|
  if ! node.is_leaf?
    size = node.each.reduce(0) { |sum, child| sum + child.content.to_i }
    puts "#{node.name} (#{size} bytes)"
    if size < 100000
      part1 = part1 + size
    end
  end
}

puts;puts part1


# Part 2