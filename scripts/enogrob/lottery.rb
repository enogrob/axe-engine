#!C:\ruby\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-02-09
# Revision : PA1
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : lottery.rb

# Purpose  : Used to provide the lottery classes.

def to_bicho(a_dezenas)
  bichos = [
    ['01', 'AVESTRUZ' , '01 02 03 04'],
    ['02', 'AGUIA'    , '05 06 07 08'],
    ['03', 'BURRO'    , '09 10 11 12'],
    ['04', 'BORBOLETA', '13 14 15 16'],
    ['05', 'CACHORRO' , '17 18 19 20'],
    ['06', 'CABRA'    , '21 22 23 24'],
    ['07', 'CARNEIRO' , '25 26 27 28'],
    ['08', 'CAMELO'   , '29 30 31 32'],
    ['09', 'COBRA'    , '33 34 35 36'],
    ['10', 'COELHO'   , '37 37 39 40'],
    ['11', 'CAVALO'   , '41 42 43 44'],
    ['12', 'ELEFANTE' , '45 46 47 48'],
    ['13', 'GALO'     , '49 50 51 52'],
    ['14', 'GATO'     , '53 54 55 56'],
    ['15', 'JACARE'   , '57 58 59 60'],
    ['16', 'LEAO'     , '61 62 63 64'],
    ['17', 'MACACO'   , '65 66 67 68'],
    ['18', 'PORCO'    , '69 70 71 72'],
    ['19', 'PAVAO'    , '73 74 75 76'],
    ['20', 'PERU'     , '77 78 79 80'],
    ['21', 'TOURO'    , '81 82 83 84'],
    ['22', 'TIGRE'    , '85 86 87 88'],
    ['23', 'URSO'     , '89 90 91 92'],
    ['24', 'VEADO'    , '93 94 95 96'],
    ['25', 'VACA'     , '97 98 99 00']
  ]

  dezenas = a_dezenas.split
  bichos.each do |dezena_bicho, nome_bicho, finais_bicho|
    dezenas.each do |dezena|
      a_dezenas.sub!(dezena, nome_bicho) if finais_bicho.include?(dezena) 
    end
  end
  a_dezenas
end

#s = to_bicho('01 10 18 25 26 46')
#puts s  
  

 