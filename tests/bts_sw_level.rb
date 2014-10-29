#!C:\Program Files\ruby-1.8\bin\ruby.exe
#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-07
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : bts_sw_level.rb
# Purpose  : Script to print the number of BTS by Software level. 
#++

require 'rubygems'
require 'axe_engine'

=begin
=List the number of BTS by Software level according printout RXMOP.
== * Input is the full specification of command log file, which shall
==   contain a RXMOP printout.
== * Output is displayed as below:
 
== e.g. bts_sw_level('C:\SAB01_pre-study.log')
== => There are:
==    60 BTSs Sw level B10532R01A.
==    : 
==    :
=end
def bts_sw_level(a_logfile)
  cmdRXMOP = cmd_get(a_logfile, 'RXMOP') 
  result = {}
  cmdRXMOP.each_index do |i|
    if cmdRXMOP[i].include?('SWVERACT')
      sw = cmdRXMOP[i+1].split.last
      if result.include?(sw)
        result[sw]+=1
      else
        result[sw]=1
      end
    end
  end
  output = ""
  output << "There are:\n"
  result.each_pair do |sw, n|
   output << "#{n} BTSs Sw level #{sw}.\n"
  end
  print output
  clip = Clipboard.instance
  clip.paste(output)
end

case ARGV.size
when 1
  bts_sw_level(ARGV[0])
else
  puts "Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C."
  puts "bts_sw_level v0.0.1"
  puts
  puts "Use: bts_sw_level.rb <rxmopfile>"
end
