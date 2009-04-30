#!/usr/bin/env ruby
#
# change-extension <path> <from-extension> <to-extension>
#
# Command line script to recursively move all files under a certain directory from
# one extension to another. Example usage: moving all .rhtml files in a Rails app to .html.erb to adopt
# the new conventions in Rails 2.

unless ARGV.size == 3
  puts "Usage: #{$0}: <path> <from-extension> <to-extension>"
  exit -1
end
root_path, from_ext, to_ext = ARGV

MOVE_COMMAND = "git mv"
Dir[File.join(root_path, "**", "*.#{from_ext}")].each do |from_path|
  to_path = from_path.chomp(from_ext) + to_ext
  command = "#{MOVE_COMMAND} #{from_path} #{to_path}"
  puts command
  system(command)
end