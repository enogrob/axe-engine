#!C:\Program Files\ruby-1.8\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-01-06
# Revision : PA1
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : fgr_collector.rb

# Purpose  : = mine/fgr.rb - FGR Client Library

class TNode
# Description : Generic node class 
    attr_reader :name, :type, :ccc, :re, :sid, :swno, :dirs, :is_blocked
    def initialize(name, type, ccc, re, sid, swno, dirs)
        @name = name
        @type = type
        @ccc = ccc
        @re = re
        @sid = sid
        @swno = swno
        @dirs = dirs
        @is_block = false
    end
    def block
        @is_blocked = true
    end
    def deblock
        @is_blocked = false
    end
    def to_s
        printf "%-26s%-7s%-17s%-5s%-4s%-8s%-6s", @name, @type, "-", @ccc, @re, @sid, @swno
    end
end

class TIOG < TNode
# Description : IOG node class
end

class TAPG < TNode
# Description : APG node class 
    attr_reader :ip
    def initialize(name, type, ccc, re, sid, swno, dirs, ip)
        super(name, type, ccc, re, sid, swno, dirs)
        @ip = ip
    end   
    def to_s
        printf "%-26s%-7s%-17s%-5s%-4s%-8s%-6s", @name, @type, @ip, @ccc, @re, @sid, @swno
    end
end

class TNodeList < Array
    def [](key)
      if key.kind_of?(Integer)
      result = [key]
    else
      result = find { |aNode| key == aNode.name }
    end
    return result
  end
end


