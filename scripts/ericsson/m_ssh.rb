#!C:\ruby\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-02-09
# Revision : PA1
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : m_ssh.rb

# Purpose  : Used to provide the ssh classes.

require 'rubygems'
require_gem 'net-ssh'#,'~>1.0.2'

Net::SSH.start('146.250.131.61', 'enogrob', 'enogrob') do |session|
  session.open_channel do |channel|
    channel.on_success do
      channel.send_data "infoXtract.sh \| head\n" 
      channel.send_data "exit\n"
    end
    channel.on_failure do
      $stderr.puts "Shell could not be started!"
    end
    channel.on_data do |ch,data|
      if (data=~/Release:/) != nil then
        oss_version=($').gsub(' ','')
        puts oss_version
      end
    end
    channel.send_request "shell", nil, true
  end
  session.loop
  session.close
end