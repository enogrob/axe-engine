#!C:\Program Files\ruby-1.8\bin\ruby.exe

# Copyright (C) 2006 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-04-05
# Revision : PA01
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : clip_exrpp_to_terdi.rb
# Load     : load 'C:\Program Files\ruby-1.8\lib\ruby\site_ruby\1.8\enogrob\ericsson.rb'
# Require  : require 'enogrob/script'
# Purpose  : Converts EXRPP printout to TERDI commands.

require 'enogrob/clip'

clip = Clipboard.instance

cmdEXRPP = []
cmdEXRPP = clip.copy.split("\r\n")

result = {}
cmdEXRPP.each do |line|
  if line =~ /RPPS1|RPG3/
    rp = line.upcase.split.first.to_i 
    type = line.upcase.split[2] 
    result[rp] = type
  end
end
result

cmdTERDI = ""
result.each_pair do |rp, type|
  cmdTERDI = cmdTERDI + "TERDI:RP= #{rp}; !    #{type} !\n" + 
  "/FILE FORMAT;\n" +
  "YES;\n" +
  "END;\n"
end

clip.paste(cmdTERDI)

