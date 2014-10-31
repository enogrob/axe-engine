#!/usr/local/bin/ruby --
require "/opt/ericsson/nms_umts_supportscript/pm_data_collection/CelloTelnet.rb"
require "/opt/ericsson/nms_umts_supportscript/pm_data_collection/readRBSdata.rb" 

LoginUser = 'PMpicker'
ServerInfo = { "ipv4addr" => "172.17.102.120",
               "user"     => "nmsadm",
               "passwd"   => "passwd"
             }

class PMXmlFileDate
  @@fileNameType = "UTC"

  def initialize(fn)
    STDERR.print "#{fn}\n"
    if fn =~ /\w(\d{4})(\d{2})(\d{2})\.(\d{2})(\d{2})\-(\d{2})(\d{2}):\d\.xml/ then
      @time_utc = Time.utc($1, $2, $3, $4, $5)
    else
      @time_utc = Time.utc(0, 1, 1, 0, 0)  # Invalid Time
    end
    @fn = fn
  end
  def isValid?(from, to)
    from.utc <= @time_utc && @time_utc < to.utc
  end
  def fileName_using_LocalTime
    if @fn =~ /(\w)\d{8}\.\d{4}\-\d{4}:(\d\.xml)/ then
      head = $1; trail = $2
      lct_s = @time_utc.localtime
      lct_e = lct_s + (15 * 60)
      nfn = sprintf("%s%04d%02d%02d.%02d%02d-%02d%02d.%s", 
               head,
               lct_s.year, lct_s.mon, lct_s.day,
               lct_s.hour, lct_s.min,
               lct_e.hour, lct_e.min,
               trail
            )
    else
      nil
    end 
  end
  def fileName_on_UnixDOS
    @fn.gsub(/:/, ".") 
  end
  def fileName
    @@fileNameType == "UTC" ? self.fileName_on_UnixDOS : self.fileName_using_LocalTime
  end
end

def check_body(node, tday = nil)
  curdir = `pwd`
  files = Array.new
  lines = ''; today = nil
  if tday.kind_of?(Time) == false then
    today0 = Time.new                                # today <- localtime
  else
    today0 = tday
  end
  today = Time.local(today0.year, today0.mon, today0.day, today0.hour, today0.min)  #get rid of usec
  today -= (today.min * 60 + today.sec)             # Adjust to xx:00:00
  yesterday = today - 86400                         # get time of yesterday (24 * 60 * 60 = 86400)

  STDERR.print "Get XML files created between #{yesterday} and #{today}\n"
#  compbase = sprintf("%04d%02d%02d", today.year, today.mon, today.day)
  begin
    STDERR.print "User=#{LoginUser},Password=#{node.passwd}\n"
    ftp = Net::Telnet.new('Host' => ServerInfo["ipv4addr"], 'Timeout' => 120, 'Prompt' => /[$%#>:] \z/n)
    ftp.login(ServerInfo["user"], ServerInfo["passwd"]){|c| print c}
    ftp.cmd("cd #{curdir}")
#   ftp.waitfor(/imt2000>[ ]?\z/n)
    ftp.cmd('Match' => /:[ ]?\z/n, 'String' => "/bin/ftp #{node.ipv4addr}") 
    ftp.cmd('Match' => /Password:\z/n, 'String' => LoginUser)
    ftp.cmd('Match' => /ftp>[ ]?\z/n, 'String' => node.passwd)
    lines = ftp.cmd("ls /c/public_html/cello/XML_files"){|c| print c}
    lines.split("\n").each do |line|
      fnchk = PMXmlFileDate.new(line)
      if fnchk.isValid?(yesterday, today) then
        STDERR.print "get /c/public_html/cello/XML_files/#{line} #{fnchk.fileName}\n" if $DEBUG
        ftp.cmd("get /c/public_html/cello/XML_files/#{line} #{fnchk.fileName}"){|c| print c}
        files.push(fnchk.fileName)
      end
    end
    ftp.cmd("bye")
  rescue TimeoutError
  end
  files
end

def do_check(rbs, ttime)
  print "\n"
  files = check_body(rbs, ttime)
  files.each do |file|
    system("/bin/unix2dos #{file} #{file}.dos")
    system("/usr/local/bin/rm #{file}")
    system("/bin/mv #{file}.dos #{file}")
  end
end


# ---- Main Proc ----
ttime = nil
rbs = $rbsdata[ARGV[0].to_s]
if ARGV.length == 2 && ARGV[1] =~ /\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}/ then
  ttime = Time.local(*ARGV[1].split(/[\- :]/))
end
if rbs != nil then
  STDERR.print "Trying to #{rbs.code} #{rbs.name} "
  while(1)
    if !rbs.icmp then
      STDERR.print "."
      redo
    end 
    do_check(rbs, ttime)
    break
  end
end

