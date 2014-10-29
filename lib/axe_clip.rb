#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-07
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : axe_clip.rb
# Purpose  : A class for handling the Clipboard.
#++

require 'singleton'
require 'thread'
require 'Win32API'

class Clipboard
  include Singleton

  CF_TEXT = 1

  def initialize
    @@mutex = Mutex.new
    @@open = Win32API.new("user32","OpenClipboard",['L'],'L')
    @@close = Win32API.new("user32","CloseClipboard",[],'L')
    @@empty = Win32API.new("user32","EmptyClipboard",[],'L')
    @@set = Win32API.new("user32","SetClipboardData",['L','P'],'L')
    @@get = Win32API.new("user32", "GetClipboardData", ['L'], 'L')
    @@lock = Win32API.new("kernel32", "GlobalLock", ['L'], 'P')
    @@unlock = Win32API.new("kernel32", "GlobalUnlock", ['L'], 'L')
  end
  
=begin
=Get information from Windows Clipboard.
== * Input has to be a String.
== * Output is send to Windows Clipboard.
== 
== e.g. cmdEXRPP = clip.copy.split("\r\n")
== 
== Note: If the imput is whole String, this has to be split first,
==       in lines, specifying CR and LF as divisor.
=end
  def copy
    @@mutex.synchronize do
      @@open.Call(0)
      str = @@lock.Call(@@get.Call(CF_TEXT))
      @@unlock.Call(@@get.Call(CF_TEXT))
      @@close.Call
      return str
    end
  end
  
=begin
=Send information to Windows Clipboard.
== * Input has to be a String.
== * Output is send to Windows Clipboard.
== 
== e.g. clip.paste(result.sort.join("\r\n"))
== 
== Note: If result is an array, this has to be to String first. Ana
==       shall be add corresponding CR and LF at each and of line.
=end
  def paste(str)
    @@mutex.synchronize do
      @@open.Call(0)
      @@empty.Call
      @@set.Call(CF_TEXT, str)
      @@close.Call
      @@lock = Win32API.new("kernel32", "GlobalLock", ['L'], 'P')
      @@unlock = Win32API.new("kernel32", "GlobalUnlock", ['L'], 'L')
      return nil
    end
  end

  private

end



