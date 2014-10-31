#!/usr/local/bin/ruby
# ---- read RBS data module
#
require 'resolv.rb'

$UTRAN_NODE_FILE = "/opt/ericsson/nms_umts_supportscript/pm_data_collection/UtranNode.txt"



class PingSupport
  @@uname = `uname`.chop
  def PingSupport.ping(ipv4addr)
    ans = false
    if @@uname == "SunOS" then
      ans = system("/usr/sbin/ping #{ipv4addr} 1 > /dev/null")
    else
      ans = system("/sbin/ping -c 1 -t 2 #{ipv4addr} > /dev/null")
    end
    if ans == false && $? / 256 != 1 then
      STDERR.print "Interrupted !!\n"
      exit
    end
    ans
  end
end

#
# ----- RBSdata class (has a RBS)
#
class RBSdata
  include Comparable
  attr_reader :rnc, :code, :name

  def <=>(dest)
    "#{self.rnc},#{self.code}" <=> "#{dest.rnc},#{dest.code}"
  end
  def initialize(tab_sep_line)
    @rnc = @code = @name = @password = @nodetype = @ipv4address = ""
    if tab_sep_line.kind_of?(String) then
      @rnc, @code, @name, @password, @nodetype, @ipv4address = tab_sep_line.split
      @code.upcase!
      unless @rnc =~ /^_RNS_.+/ then
        @rnc = "_RNS_" + @rnc
      end
    end
  end
  def ipv4addr
    if @ipv4address =~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/ then
      return @ipv4address
    else
      return Resolv.getaddress(@code).to_s
    end
  end
  def icmp
    PingSupport.ping(self.ipv4addr)
  end
  def isRBS?
    if @nodetype =~ /^RNC$/i then
      false
    else
      true
    end
  end
  def isRNC?
    return !isRBS?
  end
  def passwd
    return @password
  end
end

#
# --- Collection Classes
#
class RBSdatalist
  include Enumerable
  def each
    @rbsdata.each do |key, rbs|
      yield rbs
    end
  end
  # ---- This is an enhanced indexer for our purpose
  #      if idx is [1-7]{1} treat idx is RNC number
  #      if idx is T[A-HJ-NP-Z][0-9]{3}[A-Z]? treat idx is RBS code
  #
  def [](idx)
    if idx =~ /^_RNS_.+$/ then
      node = @rbsdata.find do |key, rbs|
        chk = rbs.rnc
        chk =~ /#{idx}/i
      end
      node[1]
    else
      @rbsdata.has_key?(idx.upcase) ? @rbsdata[idx.upcase] : nil
    end
  end
  def findall(idx)
    if idx =~ /^_RNS_.+$/ then
      @rbsdata.find_all do |key, rbs|
        chk = rbs.rnc
        chk =~ /#{idx}/i
      end.sort.collect do |key, rbs|
        rbs
      end
    else
      return @rbsdata.has_key?(idx.upcase) ? [@rbsdata[idx.upcase]] : nil
    end
  end
  def initialize(cmd)
    @rbsdata = Hash.new
    IO.popen(cmd) do |fd|
      fd.each do |line|
        next if line =~ /^#/
        rbs = RBSdata.new(line.chop)
        @rbsdata[rbs.code] = rbs
      end
    end
  end
end

# --------- Setup several kind of RBS data
$uname = `uname`; $uname.chop!
dos2unix = $uname == "SunOS" ? "/usr/bin/dos2unix" : "/usr/local/bin/dos2unix"
$rbsdata    = RBSdatalist.new("/usr/bin/cat #{$UTRAN_NODE_FILE} | #{dos2unix}")

