#!C:\ruby\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-01-23
# Revision : PA2
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : gsdc.rb

# Purpose  : = mine/gsdc.rb - GSDC Client Library

require 'ping'
require 'rubygems'
require_gem 'net-ssh','~>1.0.2'

class THost
    attr_reader :name, :ip, :type, :block_state, :user, :password
    attr_writer :user, :password
    def initialize(a_name, a_ip, a_type, a_user, a_password)
        @name = a_name
        @ip = a_ip
        @type = a_type
        @user = a_user
        @password = a_password
        @block_state = 'IDLE'
        @ping_state = ''
        ping
    end
    def setup_login(a_user, a_password)
        @user = a_user
        @password = a_password
    end
    def block
        @block_state = 'MBL'
    end
    def deblock
        @block_state = 'IDLE'
    end
    def is_blocked?
        @block_state == 'IDLE'
    end
    def ping
        if Ping.pingecho(@ip, 1)
            @ping_state = 'YES'
            true
        else
            @ping_state = 'NO'
            false
        end
    end
    def to_s
        printf "%-26s%-17s%-14s%-9s\n", @name, @ip, @type, @ping_state
    end
    def thost_methods
        ['name', 'ip', 'type', 'block_state', 'user', 'password', 'user=', 'password=', 'initialize', 'setup_login', 'block', 'deblock', 'is_blocked?', 'ping', 'to_s', 'thost_methods'].sort
    end
 end

class TBETE
    attr_reader :hosts
    attr_writer :hosts
    def initialize
        @hosts = []
        @hosts.push(THost.new('apg40ind_2', '146.250.131.250', 'APG40','ossgsdc','ossgsdc'))
        @hosts.push(THost.new('ntlap', '146.250.142.89', 'APG40','foguser','fog275'))
        @hosts.push(THost.new('ap2b', '146.250.131.246', 'APG40','gsdc','gsdc'))
    end
    def select_host(key)
      if key.kind_of?(Integer)
        @hosts[key]
      else
        @hosts.find {|a_Host| key == a_Host.name}
      end
    end
    def print_hosts
        printf "%-26s%-17s%-14s%-9s\n", 'HOST NAME', 'IP', 'TYPE', 'PINGING'
        @hosts.each {|a_Host| a_Host.to_s}
        puts 'END'
    end
end

class TOSS
    attr_reader :members, :hosts
    def initialize
        @members=[]
        @members.push({'name'=>'Zoran Ovuka (CE/EDB)','alias'=>'EZOROVU','phone'=>'+55 19 3801-7578','mobile'=> '+55 19 9167-9285'})
        @members.push({'name'=>'Roberto Nogueira (CE/EDB)','alias'=>'ENOGROB','phone'=>'+55 19 3801-7086','mobile'=> '+55 19 9219-9571'})
        @members.push({'name'=> 'Vivian Fialho (CE/EDB)','alias'=>'EVIVFIA','phone'=>'','mobile'=> '+55 19 9165-3974'})
        @hosts=[]
        @hosts.push(THost.new('ossete01,RC1.1','146.250.143.45','OSSRC1.1 CP4','ossgsdc','ossgsdc'))
        @hosts.push(THost.new('ossete01,RC2.1','146.250.142.219','OSSRC2.1','',''))
        @hosts.push(THost.new('ossete03,RC2','146.250.130.15','OSSRC2.0','',''))
        @hosts.push(THost.new('sjcmas1o,RC1.1','146.250.143.45','OSSRC1.1 CP1','',''))
    end
    def select_host(key)
      if key.kind_of?(Integer)
        @hosts[key]
      else
        @hosts.find {|a_Host| key == a_Host.name}
      end
    end
    def print_hosts
        printf "%-26s%-17s%-14s%-9s\n", 'HOST NAME', 'IP', 'TYPE', 'PINGING'
        @hosts.each {|a_host| a_host.to_s}
        puts 'END'
    end
    def toss_methods
        ['select_host', 'print_hosts', 'members', 'hosts'].sort
    end
end

class TGSDC
    attr_reader :boss, :oss
    def initialize()
        @oss = TOSS.new
        @boss={'name', 'Bjorn Arvidsson (CE/EDB)','alias', 'ETCBARI','phone','+55 19 3801-7021','mobile', '+55 19 9166-0339'} 
    end
end


gsdc = TGSDC.new

#gsdc.boss['name']
oss = gsdc.oss.select_host('ossete01,RC1.1')
puts oss.ping
#puts oss.user, oss.password
#oss.setup_login('','')
#puts oss.user, oss.password
#oss.user='ossgsdc'
#oss.password='ossgsdc'

#session = Net::SSH.start(oss.ip,oss.user,oss.password)
#session.close

#puts oss.ping
#gsdc.oss.hosts.each {|a_Host| puts a_Host.ping}
#gsdc.oss.print_hosts
#bete = TBETE.new
#bete.print_hosts
#puts bete.apg40ind_2.is_blocked?
#bete.apg40ind_2.block
#puts bete.apg40ind_2.is_blocked?

