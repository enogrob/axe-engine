#!C:\Program Files\ruby-1.8\bin\ruby.exe
#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-09
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : cmdrxpli.rb
# Purpose  : Script to generate one shot WinFIOL script in order to normalize BTSs
#            after DPPAI.
#++

require 'rubygems'
require 'axe_engine'

=begin
='cmdrxpli.rb' is a Ruby script to generate oneshot WinFIOL script with RXPLI
commands from a RXMOP log file, in order to normalize BTSs after DPPAI
e.g. can be send at once without overloading the APZ. (see attached).
=
=In order to function properly, give the correct association of the Ruby and log
file extension and also place this script in a directory which is included in
the 'Path' environment variable otherwise setup it.
== Note: This script requires AXE-ENGINE RubyGem in order to run.
== 
== e.g. C:\> cmdrxpli.rb 'C:\SAB01_pre-study.log'
== @S
== RXPLI:MO=RXOTG-41;@/END/
== @E
== @/EXECUTED/
== @/END/
== @S
== RXPLI:MO=RXOTG-100;@/END/
== @E
== @/EXECUTED/
== @/END/
== @S
== :
== Note: The output is also copied to Clipboard.
=end
def cmdrxpli(a_logfile, a_bsswanted=nil)
  cmdRXMOP = cmd_get(a_logfile, 'RXMOP')
  result = []
  cmdRXMOP.each_index do |i|
    if cmdRXMOP[i].include?('RXOTG-')
      rxotg = cmdRXMOP[i].split.first.split('-').last.to_i
      bsswanted = cmdRXMOP[i+9].split.last
      swverrepl = cmdRXMOP[i+3]
      if (swverrepl =~ /\w+/) < 32
        swverrepl = cmdRXMOP[i+3].split.first
        puts "WARNING: RXOTG-#{rxotg} has SWVERREPL=#{swverrepl}"
      end
      if a_bsswanted == nil
        result << rxotg
      elsif a_bsswanted == bsswanted
        result << rxotg
      end
    end
  end
  result.sort!
  cmdRXPLI= ""
  result.each do |rxotg|
    cmdRXPLI << "@S\n"
    cmdRXPLI << "RXPLI:MO=RXOTG-#{rxotg};@/END/\n"
    cmdRXPLI << "@E\n"
    cmdRXPLI << "@/EXECUTED/\n"
    cmdRXPLI << "@/END/\n"
  end
  clip = Clipboard.instance
  clip.paste(cmdRXPLI)
  cmdRXPLI
end

case ARGV.size
when 1
  puts cmdrxpli(ARGV[0])
else
  puts "Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C."
  puts "cmdrxpli v0.0.1"
  puts
  puts "Use: cmdrxpli.rb <rxmopfile>"
end
