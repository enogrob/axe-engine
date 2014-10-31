#!C:\Program Files\ruby-1.8\bin\ruby.exe

# Copyright (C) 2006 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-05-17
# Revision : PA13
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : fni_bsc.rb
# Load     : load "C:\\Program Files\\ruby-1.8\\lib\\ruby\\site_ruby\\1.8\\ericsson\\fni_bsc.rb"
# Require  : require 'ericsson/fni_bsc' 
# Purpose  : FNI tools

require 'enogrob/clip'
require 'FileUtils'

$LOGS_FNI_DIR = ENV['HOMEDRIVE'] + ENV['HOMEPATH'] + "\\My Documents\\My Logs FNI\\"

$SRH_TOOL_INI_FILE = "C:\\Program Files\\SRHtool\\Srhtool.ini"
$SRH_TOOL_TMP_FILE = "C:\\Program Files\\SRHtool\\Srhtool.tmp"

$SWR_R11_ACA03_21230_FILE = $LOGS_FNI_DIR + "Package R10MD-to-R11_ACA3_R3A12\\MISC\\21230\\SWR\\B18A03K3150_G.REF.swr"
$SWR_R11_ACA03_21220_FILE = $LOGS_FNI_DIR + "Package R10MD-to-R11_ACA3_R3A12\\MISC\\21220\\SWR\\B18A03J3150_G.REF.swr"

$SWR_R11_ACA04_21230_FILE = $LOGS_FNI_DIR + "Package R10MD-to-R11_ACA4_R4A06\\MISC\\21230\\SWR\\B18A04K3160_C.REF.swr"
$SWR_R11_ACA04_21220_FILE = $LOGS_FNI_DIR + "Package R10MD-to-R11_ACA4_R4A06\\MISC\\21220\\SWR\\B18A04J3160_C.REF.swr"

$SWR_R10_ACA04_21230_FILE = $LOGS_FNI_DIR + "SWRs BSC\\BSCR10MD_ACA4_21230.swr"
$SWR_R10_ACA04_21225_FILE = $LOGS_FNI_DIR + "SWRs BSC\\BSCR10MD_ACA4_21225.swr"

$SWR_R10_ACA05_21230_FILE = $LOGS_FNI_DIR + "SWRs BSC\\BSCR10MD_ACA5_21230.swr"
$SWR_R10_ACA05_21225_FILE = $LOGS_FNI_DIR + "SWRs BSC\\BSCR10MD_ACA5_21225.swr"

$SWR_R91_ACA05_21230_FILE = $LOGS_FNI_DIR + "SWRs BSC\\BSCR91MD_ACA5_21230.swr"

$FCEPS_R11_FILE = $LOGS_FNI_DIR + "Package R10MD-to-R11_ACA4_R4A06\\CMD\\fceps.ini"

class TFniBsc
  attr_accessor :log_filename, :logs_dir, :node
  
  def initialize(a_node='TGU_BSC', a_io='APG', a_rev='R9.1', a_rev_next='R10MD')
    @node = a_node.upcase
    @io = a_io.upcase
    @rev = a_rev.upcase
    @rev_next = a_rev_next.upcase
    
    @log_filename = @node + "_pre_study.log"
    
    @logs_dir = $LOGS_FNI_DIR
    Dir.chdir($LOGS_FNI_DIR)
    
    @log_shortcut = @logs_dir + @log_filename
    
    @bts_sw_min = {}
    @bts_sw_min['R9.1']={'B0471R0802' => 'RBS 200 BTS 9B'}
    @bts_sw_min['R9.1']['B0481R0802'] = 'RBS 200 BTS 9B'  
    @bts_sw_min['R9.1']['B10472R01A'] = 'RBS 200 BTS R10A'
    @bts_sw_min['R9.1']['B0472R001A'] = 'RBS 200 BTS R10A'
    @bts_sw_min['R9.1']['B10482R01A'] = 'RBS 200 BTS R10A'
    @bts_sw_min['R9.1']['B0482R001A'] = 'RBS 200 BTS R10A'
    @bts_sw_min['R9.1']['B0531R0903'] = 'RBS 2101/2X02 BTS 9C'
    @bts_sw_min['R9.1']['B10532R01A'] = 'RBS 2101/2X02 BTS 10A'
    @bts_sw_min['R9.1']['B10532R01B'] = 'RBS 2101/2X02 BTS 10A'
    @bts_sw_min['R9.1']['B0532R001B'] = 'RBS 2101/2X02 BTS 10A'
    @bts_sw_min['R9.1']['B0532R001D'] = 'RBS 2101/2X02 BTS 10A/9D'
    @bts_sw_min['R9.1']['B10532R01D'] = 'RBS 2101/2X02 BTS 10A/9D'
    @bts_sw_min['R9.1']['B0532R001F'] = 'RBS 2101/2X02 BTS 10A_1/9D_1'
    @bts_sw_min['R9.1']['B10532R01F'] = 'RBS 2101/2X02 BTS 10A_1/9D_1'
    @bts_sw_min['R9.1']['B0532R002A'] = 'RBS 2101/2X02 BTS 10B/9E'
    @bts_sw_min['R9.1']['B10532R02A'] = 'RBS 2101/2X02 BTS 10B/9E'
    @bts_sw_min['R9.1']['B1192R0804'] = 'RBS 2X06/2207/2308 BTS 9.1B'
    @bts_sw_min['R9.1']['B1921R0914'] = 'RBS 2X06/2207/2308 BTS 9.1C'
    @bts_sw_min['R9.1']['B1921R0915'] = 'RBS 2X06/2207/2308 BTS 9.1C2'
    @bts_sw_min['R9.1']['B11922R01A'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B1922R001A'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B11922R01B'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B1922R001B'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B11922R01C'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B1922R001C'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B11922R01D'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B1922R001D'] = 'RBS 2X06/2207/2308 BTS 10.1A'
    @bts_sw_min['R9.1']['B11922R01E'] = 'RBS 2X06/2207/2308 BTS 10.1A /9.1E'
    @bts_sw_min['R9.1']['B1922R001E'] = 'RBS 2X06/2207/2308 BTS 10.1A /9.1E'
    @bts_sw_min['R9.1']['B11922R02H'] = 'RBS 2X06/2207/2308 BTS 10.1B/9.1F'
    @bts_sw_min['R9.1']['B1922R002H'] = 'RBS 2X06/2207/2308 BTS 10.1B/9.1F'
    @bts_sw_min['R9.1']['B11922R02N'] = 'RBS 2X06/2207/2308 BTS 10.1C/9.1G'
    @bts_sw_min['R9.1']['B1922R002N'] = 'RBS 2X06/2207/2308 BTS 10.1C/9.1G'
    
    @iog_sw_min = {}
    @iog_sw_min['R9.1'] = ['BSC14U08_113020A']
    @iog_sw_min['R9.1'] << 'BSC14A01_114020A'
    @iog_sw_min['R9.1'] << 'BSC14A03_118020A'
    @iog_sw_min['R9.1'] << 'BSC14A05_120020A'
    @iog_sw_min['R9.1'] << 'BSC14A06_124020A'
    @iog_sw_min['R9.1'] << 'BSC14A07_127010A'
    
    @iog_sw_new = {}
    @iog_sw_new['R9.1'] = 'BSC17A04_219020A'
    
    @transcoder_sw_min = {}
    @transcoder_sw_min['R9.1'] = {'CAA 146 0021 R4A01' => 'ETM1D'}
    @transcoder_sw_min['R9.1']['CAA 146 0022 R6A02'] = 'ETM1D'  
    @transcoder_sw_min['R9.1']['CXCW 200 001 R3C01'] = 'RTTF1S1D'
    @transcoder_sw_min['R9.1']['CXCW 200 002 R3C01'] = 'RTTF1S2D'
    @transcoder_sw_min['R9.1']['CXCW 201 005 R2B01'] = 'RTTF1SD'
    @transcoder_sw_min['R9.1']['CAAW 200 004 R2A   (5V)'] = 'RTTF2SD'
    @transcoder_sw_min['R9.1']['CXCW 201 004 R2B01 (3V)'] = 'RTTF2SD'
    @transcoder_sw_min['R9.1']['CXCW 200 003 R3C01'] = 'RTTH1SD'
    @transcoder_sw_min['R9.1']['CAAW 200 007 R1A  '] = 'RTTH2SD'
    
    @apz = get_apz
  end
  
  def get_apz
    cmdSAOSP = get_cmd('SAOSP')
    apz_type  = cmdSAOSP.grep(/APZ TYPE/).to_s.split[-3]
    apz_version = cmdSAOSP.grep(/APZ VERSION/).to_s.split[-3]
    @apz = {:apz_type => apz_type, :apz_version => apz_version}
  end
  
  def node=(a_node)
    @node = a_node 
    @log_filename = @node + "_pre_study.log"
  end
  
  def log_shortcut
    @log_shortcut = @logs_dir + @log_filename
  end
  
  def get_cmds
    if !File.exist?(log_shortcut)
       puts "=> File: #{@log_filename} do not exist !"
       return
    end
    result =[]
    File.open(log_shortcut, 'r') do |file|
      file.each do |line| 
        result << line.upcase.chomp.rstrip if line =~ /\A(\<|:)(\w{5,5})(:|;)/  
      end
    end
    result.sort
  end
  
  def read_log_file
    if !File.exist?(log_shortcut)
       puts "=> File: #{@log_filename} do not exist !"
       return
    end
    result = []
    File.open(log_shortcut, 'r') do |file|
      result = file.readlines
    end
    result
  end
  
  def get_cmd(a_command)
    if !File.exist?(log_shortcut)
       puts "=> File: #{@log_filename} do not exist !"
       return
    end
    result = []
    File.open(log_shortcut, 'r') do |file|
      while line = file.gets
        line.upcase!
        next if ! line.include?(a_command.upcase)
        result << line.upcase.chomp.rstrip
        break line
      end
      while line = file.gets
        result << line.upcase.chomp.rstrip
        next if ! (line =~ /^END/)
        break line 
      end
    end
    result
  end
  
  def bts_sw_level
    cmdRXMOP = get_cmd('RXMOP') 
    result = {}
    cmdRXMOP.each_index do |i|
      if cmdRXMOP[i].include?('SWVERACT')
        sw = cmdRXMOP[i+1].split.last
        if result.include?(sw)
          result[sw]+=1
        else
          result[sw]=1
        end
      end
    end
    puts "There are:"
    result.each_pair do |sw, n|
      print "#{n} BTSs Sw level #{sw}."
      @bts_sw_min[@rev].each_pair do |sw_min, bts|
        if (sw[0, 4] == sw_min[0, 4]) and (sw[5, 9] >= sw_min[5, 9])
          puts "This version (min. #{sw_min}) is supported on #{@rev_next} and work properly."
          break
        end
      end
    end
#    puts "The BSC has the minimum requirements that needs to be met for BTS software."
#    @bts_sw_min[@rev].each_pair do |sw_min, trc|
#      printf "%-8s %s \n", trc, sw_min
#    end
  end

  def memory_impact(a_inc=10)
    cmdSASTP = get_cmd('SASTP')
    ps  = cmdSASTP.grep(/PHYSICAL STORE/).to_s.split.last.to_f
    taa = cmdSASTP.grep(/TOTAL ALLOCATED AREAS/).to_s.split.last.to_f
    r9  = (taa / ps) * 100
    r10 = r9 * (1 + a_inc/100.0)
    printf "At the present moment this BSC has a memory usage in %s of %.2f %%.\n", @rev, r9
    printf "After the upgrade to %s the memory usage will be increased approximately to %.2f %%, which is rather good for this upgrade.\n", @rev_next, r10
  end
  
  def iog_support
    cmdLASYP = get_cmd('LASYP')
    sw = cmdLASYP.grep(/ACTIVE/).to_s.split.first
    puts "IOG SP System Level for this BSC is #{sw}."
    @iog_sw_min[@rev].each do |sw_min|
      if (sw[0, 7] == sw_min[0, 7]) and (sw[9, 15] >= sw_min[9, 15])
        puts "This SP system (min. #{sw_min}) is supported for SP System Upgrade."
        break
      end
    end
    puts "After the SP System Upgrade, the new system will be #{@iog_sw_new[@rev]}." 
  end
  
  def rxpli(a_bsswanted=nil)
    cmdRXMOP = get_cmd('RXMOP')
    result = []
    cmdRXMOP.each_index do |i|
      if cmdRXMOP[i].include?('RXOTG-')
        rxotg = cmdRXMOP[i].split.first.split('-').last.to_i
        bsswanted = cmdRXMOP[i+9].split.last
        swverrepl = cmdRXMOP[i+3]
        if (swverrepl =~ /\w+/) < 32
          swverrepl = cmdRXMOP[i+3].split.first
          puts "WARNING: RXOTG-#{rxotg} has SWVERREPL=#{swverrepl}"
        end
        if a_bsswanted == nil
          result << rxotg
        elsif a_bsswanted == bsswanted
          result << rxotg
        end
      end
    end
    result.sort!
    cmdRXPLI= ""
    result.each do |rxotg|
      cmdRXPLI << "@S\n"
      cmdRXPLI << "RXPLI:MO=RXOTG-#{rxotg};@/END/\n"
      cmdRXPLI << "@E\n"
      cmdRXPLI << "@/EXECUTED/\n"
      cmdRXPLI << "@/END/\n"
    end
    clip = Clipboard.instance
    clip.paste(cmdRXPLI)
    cmdRXPLI
  end
  
  def rxasp
    cmdRXASP = get_cmd('RXASP')
    result = []
    cmdRXASP.each do |line|
      if line.include?('TS SYNC FAULT')
        result << line.split.first
      end
    end
    result.sort!
    cmdRXASP= ""
    result.each do |rxots|
      cmdRXASP << "@S\n" 
      cmdRXASP << "RXBLI:MO=#{rxots};\n"
      cmdRXASP << "RXTEI:MO=#{rxots};\n"
      cmdRXASP << "@E\n"
      cmdRXASP << "@/NO FAULT INDICATIONS/\n"
      cmdRXASP << "@/END/\n" 
      cmdRXASP << "@S\n"
      cmdRXASP << "RXBLE:MO=#{rxots};\n"
      cmdRXASP << "RXASP:MO=#{rxots};\n"
    end
    clip = Clipboard.instance
    clip.paste(cmdRXASP)
    cmdRXASP
  end

  def transcoder_in_bsc
    cmdRRDSP = get_cmd('RRDSP')
    result = {}
    cmdRRDSP.each_index do |i|
      if cmdRRDSP[i].include?('SUID')
        sw = cmdRRDSP[i+1]
        if result.include?(sw)
          result[sw]+=1
        else
          result[sw]=1
        end
      end
    end
    puts "There are:"
    result.each_pair do |sw, n|
      printf "%+3s %s %s transcoder(s).", n, sw[0, 12], sw[25, 29]
      @transcoder_sw_min[@rev].each_pair do |sw_min, trc|
        if (sw[0, 12] == sw_min[0, 12]) and (sw[25, 29] >= sw_min[12, 16])
          puts "This version is supported on #{@rev_next} as minimal requirement (min. #{sw_min})."
          break
        end
      end
    end
#   puts
#   puts "The BSC has the minimum requirements that needs to be met for transcoders."
#   @transcoder_sw_min[@rev].each_pair do |sw_min, trc|
#     printf "%-8s %s \n", trc, sw_min
#   end
  end
  
  def terdi
    cmdEXRPP = get_cmd('EXRPP')
    result = {}
    cmdEXRPP.each do |line|
      if line =~ /RPPS1|RPPP1/
        rp = line.upcase.split.first.to_i 
        type = line.upcase.split[2] 
        result[rp] = type
      end
    end
    cmdTERDI = ""
    result.each_pair do |rp, type|
      cmdTERDI = cmdTERDI + "TERDI:RP= #{rp}; !    #{type} !\n" + 
      "/FILE FORMAT;\n" +
      "YES;\n" +
      "END;\n"
    end
    clip = Clipboard.instance
    clip.paste(cmdTERDI)
    cmdTERDI
  end
  
  def pre_study
    memory_impact
    puts
    iog_support if @io.include?('IOG') 
    puts
    bts_sw_level
    puts
    transcoder_in_bsc
  end
  
  def gen_swr
    fprefix = $LOGS_FNI_DIR + @node + '_pre_study_'
    if !File.exist?($SRH_TOOL_TMP_FILE) 
       puts "=> File: #{$SRH_TOOL_TMP_FILE} do not exist !"
       return
    elsif !File.exist?($SRH_TOOL_INI_FILE)
       puts "=> File: #{$SRH_TOOL_TMP_FILE} do not exist !"
       return
    elsif !File.exist?(fprefix + 'LASIP.log')
       puts "=> File: " + fprefix + "LASIP.log" + " do not exist !"
       return
    elsif !File.exist?(fprefix + 'LAFBP.log')
       puts "=> File: " + fprefix + "LAFBP.log" + " do not exist !"
       return
    elsif !File.exist?(fprefix + 'PCORP.log')
       puts "=> File: " + fprefix + "PCORP.log" + " do not exist !"
       return
    elsif !File.exist?(fprefix + 'LAEIP.log')
       puts "=> File: " + fprefix + "LAEIP.log" + " do not exist !"
       return
    elsif !File.exist?(fprefix + 'PCECP.log')
       puts "=> File: " + fprefix + "PCECP.log" + " do not exist !"
       return
    end
    File.open($SRH_TOOL_TMP_FILE, 'w') do |srhtool_tmp|
      File.open($SRH_TOOL_INI_FILE, 'r') do |srhtool_ini|   
        while line = srhtool_ini.gets
          if    line.include?('MainView.CreateA_SWR_Settings.LASIP_File=')
            srhtool_tmp.puts 'MainView.CreateA_SWR_Settings.LASIP_File=' + fprefix + 'LASIP.log'
          elsif line.include?('MainView.CreateA_SWR_Settings.LAFBP_File=')
            srhtool_tmp.puts 'MainView.CreateA_SWR_Settings.LAFBP_File=' + fprefix + 'LAFBP.log'
          elsif line.include?('MainView.CreateA_SWR_Settings.PCORP_File=')
            srhtool_tmp.puts 'MainView.CreateA_SWR_Settings.PCORP_File=' + fprefix + 'PCORP.log'
          elsif line.include?('MainView.CreateA_SWR_Settings.LAEIP_File=')
            srhtool_tmp.puts 'MainView.CreateA_SWR_Settings.LAEIP_File=' + fprefix + 'LAEIP.log'
          elsif line.include?('MainView.CreateA_SWR_Settings.PCECP_File=')
            srhtool_tmp.puts 'MainView.CreateA_SWR_Settings.PCECP_File=' + fprefix + 'PCECP.log'
          elsif line.include?('MainView.CompareTwoSWRsSettings.Reference_SWR=')
            if @apz[:apz_version].include?('3')
              srhtool_tmp.puts 'MainView.CompareTwoSWRsSettings.Reference_SWR=' + $SWR_R10_ACA04_21230_FILE
            else
              srhtool_tmp.puts 'MainView.CompareTwoSWRsSettings.Reference_SWR=' + $SWR_R10_ACA04_21225_FILE
            end
          elsif line.include?('MainView.CompareTwoSWRsSettings.Compare_SWR=')
            srhtool_tmp.puts 'MainView.CompareTwoSWRsSettings.Compare_SWR=' + $LOGS_FNI_DIR + @node + '.swr' 
          elsif line.include?('MainView.LoadA_SWR_Settings.SWR_File=')
            srhtool_tmp.puts 'MainView.LoadA_SWR_Settings.SWR_File=' + $LOGS_FNI_DIR + @node + '.swr'                 
          else 
            srhtool_tmp.puts line
          end
        end
      end
    end
    FileUtils.cp($SRH_TOOL_TMP_FILE, $SRH_TOOL_INI_FILE) 
    2.times {|i| `C:\\Program Files\\SRHtool\\Srhtool.exe`} 
  end
  
  def check_fceps
    rps_R10 = get_rps_swr($LOGS_FNI_DIR + @node + '.swr')
    if @apz[:apz_version].include?('3')
      rps_R11_ref = get_rps_swr($SWR_R11_ACA04_21230_FILE)
    else
      rps_R11_ref = get_rps_swr($SWR_R11_ACA04_21220_FILE)
    end
    rps_fceps = get_rps_fceps($FCEPS_R11_FILE)
    result = []
    rps_R10.each do |rp|
      if !rps_fceps.include?(rp) and !rps_R11_ref.include?(rp)
        result << rp
      end
    end
    result
  end
  
  def fni_methods
    (self.methods - Object.methods).sort
  end
  
private

  def get_rps_swr(a_file)
    result = []
    File.open(a_file, 'r') do |file|
      while line = file.gets
        next if ! (line =~ /^\)BEGIN APZ-RP/)
        break line
      end
      while line = file.gets
        result << line.chomp
        next if ! (line =~ /^\)END APZ-RP/)
        result.pop
        break line 
      end 
    end
    result.each {|rp| rp.slice!(1..18)}
    result.each {|rp| rp.slice!(32..41)}
    rps = []
    result.each do |rp|
      rps << [rp[0, 23].strip.squeeze(' '), rp[24, rp.length].strip] if rp!=nil 
    end
    rps
  end
  
  def get_rps_fceps(a_file)
    result = []
    pos_ini = 0
    File.open(a_file, 'r') do |file|
      while line = file.gets
        pos_ini = (line =~ /Old-Suid/) if line =~ /Old-Suid/
        next if ! (line =~ /^CAA/)
        break line
      end
      while line = file.gets
        result << line.chomp[pos_ini, line.length]
      end 
    end
    rps = []
    result.each do |rp|
      rps << [rp[0, 23].strip.squeeze(' '), rp[24, rp.length].strip] if rp!=nil 
    end
    rps
  end
  
end
##fni = TFniBsc.new('BSCTGU1')
##fni.check_fceps
