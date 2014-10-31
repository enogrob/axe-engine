#!C:\Program Files\ruby-1.8\bin\ruby.exe

# Copyright (C) 2006 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-05-06
# Revision : PA2
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : script.rb
# Load     : load "C:\\Program Files\\ruby-1.8\\lib\\ruby\\site_ruby\\1.8\\ericsson\\fni_bsc.rb"
# Purpose  : Script description

# Gives a quick list of an objects methods.
# Useful in IRB and breakpoint. Just put this in your ~/.irbrc
# (c) Assaph Mehr, 2005. Licensed as Ruby.

require 'irb/completion'
require 'ericsson/etravel'
#require 'ericsson/eval'

$HOME_DIR = "C:\\Documents and Settings\\" + ENV['USERNAME'] + "\\My Documents"

def mds thing
  case thing
  when Class, Module
    print 'class: '
    thing.methods.sort - Class.methods
  else
    print "object of class #{thing.class}: "
    thing.methods.sort - Object.instance_methods
  end
end

def ipconfig (a_par='reset')
  if a_par == 'reset'
    puts `ipconfig /release`
    sleep 2
    puts `ipconfig /renew`
  elsif a_par == '/all'
    puts `ipconfig /all`
  end
end

def which f_name
   ENV['PATH'].split(';').map { |p| File.join p, f_name }.find { |p| File.file? p and File.executable? p }
end

def killbugs
  if `pslist`.grep(/cisvc/).to_s.include? 'cisvc'
    `pskill cisvc`
    puts "=> \"cisvc\" process was killed."
  end
  sleep(2)
  if `pslist`.grep(/scanw32/).to_s.include? 'scanw32'
    `pskill scanw32` 
    puts "=> \"scanw32\" process was killed."
  end
  sleep(2)
end

def killesoe
  if `pslist`.grep(/ECC/).to_s.include? 'ECC'
    `pskill ECC`
    puts "=> \"ECC\" process was killed."
  end
  sleep(2)
  if `pslist`.grep(/ControlCenter.e/).to_s.include? 'ControlCenter.e'
    `pskill ControlCenter.e` 
    puts "=> \"ControlCenter.e\" process was killed."
  end
  sleep(2)
end

def dir arg='.'
  puts `dir #{arg}` 
end

def cd arg='.'
  Dir.chdir arg
end

$e = Etravel.new

Dir.chdir $HOME_DIR


 
