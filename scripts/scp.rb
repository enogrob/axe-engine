require 'rubygems'
require 'net/ssh'
def copy_file(session, source_path, destination_path=nil)
destination_path ||= source_path
cmd = %{cat > "#{destination_path.gsub('"', '\"')}"}
session.process.popen3(cmd) do |i, o, e|
puts "Copying #{source_path} to #{destination_path}... "
open(source_path) { |f| i.write(f.read) }
puts 'Done.'
end
end
Net::SSH.start('example.com', :username=>'leonardr',
:password=>'mypass') do |session|
copy_file(session, '/home/leonardr/scripts/test.rb')
copy_file(session, '/home/leonardr/scripts/"test".rb')
end
# Copying /home/leonardr/scripts/test.rb to /home/leonardr/scripts/test.rb...
# Done.
# Copying /home/leonardr/scripts/"test".rb to /home/leonardr/scripts/"test".rb...
# Done.

 -rw-rw-r-- 1 leonardr leonardr 33 Dec 29 20:40 file1
# -rw-rw-r-- 1 leonardr leonardr 102 Dec 29 20:40 file2
You can run a sequence of commands in a single user shell bycalling session.shell.
sync:
Net::SSH.start('example.com', :username=>'leonardr',
:password=>'mypass') do |session|
shell = session.shell.sync
puts "Original working directory: #{shell.pwd.stdout}"
shell.cd 'test_dir'
puts "Working directory now: #{shell.pwd.stdout}"
puts 'Directory contents:'
puts shell.ls("-l").stdout
shell.exit
end
# Original working directory: /home/leonardr
# Working directory now: /home/leonardr/test_dir
# Directory contents: