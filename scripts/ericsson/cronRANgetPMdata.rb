#!/usr/local/bin/ruby --

$BASEDIR = "/var/opt/ericsson/nms_umts_supportscript/pm_data_files"
$RNCLIST = %w( TRNC1 TRNC2 TRNC3 TRNC4 TRNC5 TRNC6 TRNC7 )
$TIME    = '00:00'
$subCommand = "/opt/ericsson/nms_umts_supportscript/pm_data_collection/RANgetPMdata"

today = Time.new
dir = sprintf("%04d%02d%02d", today.year, today.mon, today.day)
zipfn = sprintf("%02d%02d%02d", today.year % 2000, today.mon, today.day)
time = sprintf("%04d-%02d-%02d %s", today.year, today.mon, today.day, $TIME)

Dir.chdir($BASEDIR)
  STDERR.print(`pwd`)
  Dir.mkdir(dir)
  Dir.chdir(dir)
    STDERR.print(`pwd`)
    $RNCLIST.each do |rnc|
      Dir.mkdir(rnc)
      Dir.chdir(rnc)
        STDERR.print(`pwd`)
        system("#{$subCommand} #{rnc} '#{time}'")
      Dir.chdir("..")
    end
  Dir.chdir("..")
  STDERR.print(`pwd`)
  system("/bin/zip -r -m #{zipfn}_xml_files.zip #{dir}")

