#!C:\Program Files\ruby-1.8\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-01-25
# Revision : PA1
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : clip_refkey.rb
# Load     : load 'C:\Program Files\ruby-1.8\lib\ruby\site_ruby\1.8\enogrob\clip_refkey.rb'
# Require  : require 'enogrob/clip'
# Purpose  : Used to provide the ref. key in one click to the cliboard.

require 'enogrob/clip'

key = {'01' => '422', '11' => '511', '21' => '216', '31' => '507', '41' => '421', '51' => '153', '61' => '638',
       '02' => '983', '12' => '356', '22' => '170', '32' => '551', '42' => '736', '52' => '815', '62' => '231',
       '03' => '604', '13' => '922', '23' => '065', '33' => '423', '43' => '045', '53' => '243', '63' => '396',
       '04' => '394', '14' => '812', '24' => '393', '34 '=> '049', '44' => '928', '54' => '460', '64' => '362',
       '05' => '334', '15' => '306', '25' => '202', '35' => '256', '45' => '465', '55' => '389', '65' => '244',
       '06' => '655', '16' => '586', '26' => '296', '36' => '439', '46' => '257', '56' => '498', '66' => '402',
       '07' => '146', '17' => '751', '27' => '140', '37 '=> '631', '47' => '729', '57' => '166', '67' => '742',
       '08' => '582', '18' => '145', '28' => '020', '38' => '502', '48' => '966', '58' => '411', '68' => '162',
       '09' => '282', '19' => '483', '29' => '895', '39' => '205', '49' => '429', '59' => '251', '69' => '235',
       '10' => '201', '20' => '461', '30' => '181', '40' => '769', '50' => '241', '60' => '175', '70' => '255'}

clip = Clipboard.instance 
keynr = clip.copy
clip.paste(key[keynr])
puts key[keynr]
gets
