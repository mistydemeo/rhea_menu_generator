#!/usr/bin/env ruby

require "fileutils"
include FileUtils

$stderr.puts "Restoring original directory names..."
Dir["*/.orig"].each do |record|
  current = File.dirname record
  original = File.read(record).chomp
  mv current, original
end

$stderr.puts "Renaming games to numbered directories..."
n = 2
Dir["*"].sort.each do |dir|
  next unless File.directory? dir
  next if dir == "01" # RMENU is already installed in the right spot

  # track the original directory name
  unless File.exist? "#{dir}/.orig"
    $stderr.puts "Remembering original path for #{dir}..."
    File.open("#{dir}/.orig", "w") {|f| f.puts dir}
  end

  new_path = "%02d" % n
  $stderr.puts "#{dir} => #{new_path}"
  mv dir, new_path
  n += 1
end

$stderr.puts "Generating menu..."
# runs the RMENU setup to generate the menu, which is interactive
cd "01" do
  system "wine", "RMENU.exe"
end

$stderr.puts
$stderr.puts "Done! ✨ ♄✨"
