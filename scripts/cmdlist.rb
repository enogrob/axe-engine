#!C:\Program Files\ruby-1.8\bin\ruby.exe
#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-07
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : cmdlist.rb
# Purpose  : Script to list and the AXE commands in a cmdfile.
#++

require 'rubygems'
require 'axe_engine'

=begin
=List AXE commands specifications contained in a command log file.
== * Input is the full specification of command log file.
== * Output is an sorted list of AXE command specifications.
== 
== e.g. C:\> cmdlist.rb 'C:\SAB01_pre-study.log'
== IOEXP;
== CACLP;
== :
== Note: The output is also copied to Clipboard.
=end
case ARGV.size
when 1
  puts cmd_list(ARGV[0])
else
  puts "Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C."
  puts "cmdlist v0.0.1"
  puts
  puts "Use: cmdlist.rb <cmdfile>"
end
