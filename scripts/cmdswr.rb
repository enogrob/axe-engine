

$LOGS_FNI_DIR = ENV['HOMEDRIVE'] + ENV['HOMEPATH'] + "\\My Documents\\My Logs FNI\\"
$SRH_TOOL_INI_FILE = "C:\\Program Files\\SRHtool\\Srhtool.ini"
$SRH_TOOL_TMP_FILE = "C:\\Program Files\\SRHtool\\Srhtool.tmp"

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