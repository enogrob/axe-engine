#!C:\Program Files\ruby-1.8\bin\ruby.exe
#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-07
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : axe_engine.rb
# Purpose  : A package for handling Ericsson AXE printouts.
#++

require 'rubygems'
require 'axe_clip'

=begin
=List AXE commands specifications contained in a command log file.
== * Input is the full specificcation of command log file.
== * Output is an sorted array of AXE command specifications.
== 
== e.g. cmdlist('C:\SAB01_pre-study.log')
== => ['IOEXP;', 'CACLP;', ..]
== 
== Note: The output is also copied to Clipboard.
=end
def cmd_list(a_cmdfile)
  clip = Clipboard.instance
  if !File.exist?(a_cmdfile)
     clip.paste("=> File: #{a_cmdfile} do not exist !\r\n")
     puts "=> File: #{a_cmdfile} do not exist !"
     return
  end
  result =[]
  File.open(a_cmdfile, 'r') do |file|
    file.each do |line| 
      result << line.slice(/(\w{5,5})(:|;)((\w|:|=|;|,|\s|-)*)/).upcase.chomp.rstrip if line =~ /\A(\<|:)(\w{5,5})(:|;)/ 
    end
  end
  clip.paste(result.sort.join("\r\n"))
  result.sort
end

=begin
=Get an AXE command printout contained in a command log file.
== * Input is the full specificcation of command log file, and the AXE
==   command.
== * Output is an array of AXE command printout.
== e.g. cmdget('C:\SAB01_pre-study.log', 'CACLP;')
== => ['<CACLP;', ..]
== 
== Note: The output is also copied to Clipboard.
=end  
def cmd_get(a_cmdfile, a_command)
  clip = Clipboard.instance
  if !File.exist?(a_cmdfile)
     clip.paste("=> File: #{a_cmdfile} do not exist !\r\n")
     puts "=> File: #{a_cmdfile} do not exist !"
     return
  end 
  result = []
  File.open(a_cmdfile, 'r') do |file|
    while line = file.gets
      line.upcase!
      next if ! line.include?(a_command.upcase)  
      result << line.chomp.rstrip
      break line
    end
    while line = file.gets
      line.upcase!
      result << line.chomp.rstrip
      next if ! (line =~ /^END/)
      break line 
    end
  end
  clip.paste(result.join("\r\n"))
  result
end
 
def cmd_methods
  (self.methods - Object.methods).sort
end

