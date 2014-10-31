#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-05
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : which.rb
# Purpose  : Give the path of a executable program specified as parameter.
#++

def search(f_name) 
  yield ENV['PATH'].split(';').map {|p| File.join p, f_name}.find {|p| File.file? p and File.executable? p}
end

def which(f_name)
  f_path = nil
  search(f_name) {|f_path| puts f_path if f_path != nil} 
  search(f_name += '.exe') {|f_path| puts f_path} if f_path == nil and !f_name.include? 'exe'
end

if ARGV.size != 1
  puts "Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C."
  puts "which v0.0.1"
  puts
  puts "Use: which.rb <program>"
else
  which(ARGV[0])
end
