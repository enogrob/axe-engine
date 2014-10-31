#!C:\ruby\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-01-22
# Revision : PA2
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : gsdc.rb

# Purpose  : = mine/gsdc.rb - GSDC Client Library

require 'ping'

class THost
    attr_reader :name, :ip, :type, :block_state
    def initialize(a_name, a_ip, a_type)
        @name = a_name
        @ip = a_ip
        @type = a_type
        @block_state='IDLE'
        @ping_state=''
        ping
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
        ['name', 'ip', 'type', 'block_state','block', 'deblock', 'is_blocked?', 'ping', 'to_s', 'thost_methods'].sort
    end
 end

class TBETE
    attr_reader :apg40ind_2, :ntlap, :hosts
    attr_writer :hosts
    def initialize
        @apg40ind_2 = THost.new('apg40ind_2', '146.250.131.250', 'APG40')
        @ntlap = THost.new('ntlap', '146.250.142.89', 'APG40')
        @hosts = []
        @hosts.push(@apg40ind_2)
        @hosts.push(@ntlap)
    end
    def print_hosts
        printf "%-26s%-17s%-14s%-9s\n", 'HOST NAME', 'IP', 'TYPE', 'PINGING'
        @hosts.each {|a_host| a_host.to_s}
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
        @hosts.push(THost.new('ossete01,RC1.1','146.250.131.61','OSSRC1.1 CP4'))
        @hosts.push(THost.new('ossete01,RC2.1','146.250.142.219','OSSRC2.1'))
        @hosts.push(THost.new('ossete03,RC2','146.250.130.15','OSSRC2.0'))
        @hosts.push(THost.new('sjcmas1o,RC1.1','146.250.143.45','OSSRC1.1 CP1'))
    end
    def print_hosts
        printf "%-26s%-17s%-14s%-9s\n", 'HOST NAME', 'IP', 'TYPE', 'PINGING'
        @hosts.each {|a_host| a_host.to_s}
        puts 'END'
    end
end

class TGSDC
    attr_reader :boss, :oss
    def initialize()
        @oss = TOSS.new
        @boss={'name', 'Bjorn Arvidsson (CE/EDB)','alias', 'ETCBARI','phone','+55 19 3801-7021','mobile', '+55 19 9166-0339'} 
    end
end

#gsdc = TGSDC.new

#gsdc.boss['name']
#gsdc.oss.members.each {|a_member| a_member['name']}
#gsdc.oss.print_hosts
#bete = TBETE.new
#bete.print_hosts
#puts bete.apg40ind_2.is_blocked?
#bete.apg40ind_2.block
#puts bete.apg40ind_2.is_blocked?

