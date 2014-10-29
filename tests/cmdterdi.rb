#!C:\Program Files\ruby-1.8\bin\ruby.exe
#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-08
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : cmdterdi.rb
# Purpose  : Script to generate TERDI commands accordingto EXRPP, to be send
#            before FCSEI.
#++

require 'rubygems'
require 'axe_engine'

=begin
=It is a Ruby script to generate TERDI commands from a EXRPP log
file, in order to send to BSC before FCSEI (see attached).
=
=In order to function properly, give the correct association of the Ruby and log
file extension and also place this script in a directory which is included in
the 'Path' environment variable otherwise setup it.
== Note: This script requires AXE-ENGINE RubyGem in order to run.
== 
== e.g. C:\> cmdterdi.rb 'C:\SAB01_pre-study.log'
== TERDI:RP= 165; !    RPPS1 !
== /FILE FORMAT;
== YES;
== END;
== TERDI:RP= 166; !    RPPS1 !
== /FILE FORMAT;
== YES;
== END;
== :
== Note: The output is also copied to Clipboard.
=end
def cmdterdi(a_logfile)
  cmdEXRPP = cmd_get(a_logfile, 'EXRPP')
  result = {}
  cmdEXRPP.each do |line|
    if line =~ /RPPS1|RPPP1/
      rp = line.upcase.split.first.to_i 
      type = line.upcase.split[2] 
      result[rp] = type
    end
  end
  cmdTERDI = ""
  result.each_pair do |rp, type|
    cmdTERDI = cmdTERDI + "TERDI:RP= #{rp}; !    #{type} !\n" + 
    "/FILE FORMAT;\n" +
    "YES;\n" +
    "END;\n"
  end
  clip = Clipboard.instance
  clip.paste(cmdTERDI)
  cmdTERDI
end

case ARGV.size
when 1
  puts cmdterdi(ARGV[0])
else
  puts "Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C."
  puts "cmdterdi v0.0.1"
  puts
  puts "Use: cmdterdi.rb <terdifile>"
end
