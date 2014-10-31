#!/usr/bin/env ruby -w
# win32 only

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

  def copy
    @@mutex.synchronize do
      @@open.Call(0)
      str = @@lock.Call(@@get.Call(CF_TEXT))
      @@unlock.Call(@@get.Call(CF_TEXT))
      @@close.Call

      return str
    end
  end

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



