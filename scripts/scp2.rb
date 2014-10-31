require 'rubygems'
require 'net/ssh'

Net::SSH.start('146.250.131.61', :username=>'enogrob',
:password=>'isis01') do |session|
  cmd = ['isql -Usa -Psybase11',
         'sp_helpdb',
         'go']
  cmd.each do |a_cmd|
    session.process.popen3(a_cmd) do |stdin, stdout, stderr|
      puts stdout.read
    end
  end
end
#