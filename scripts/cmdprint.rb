#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-07
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : cmdprint.rb
# Purpose  : Script to print a AXE command from a cmdfile.
#++

require 'rubygems'
require 'axe_engine'

=begin
=Get an AXE command printout contained in a command log file.
== * Input is the full specification of command log file, and the AXE
==   command.
== * Output is printout of AXE command specified.
== e.g. C:\> cmdprint.rb 'C:\SAB01_pre-study.log' 'CACLP;'
== <CACLP;
== : 
== Note: The output is also copied to Clipboard.
=end  
case ARGV.size
when 2
  puts cmd_get(ARGV[0], ARGV[1])
else
  puts "Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C."
  puts "cmdprint v0.0.1"
  puts
  puts "Use: cmdprint.rb <cmdfile> <cmd>"
end
