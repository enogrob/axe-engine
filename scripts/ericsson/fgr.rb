#!C:\Program Files\ruby-1.8\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-02-06
# Revision : PA2
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : fgr.rb

# Purpose  : = 'enogrob/fgr' - FGR Library

require 'ping'
require 'rubygems'
require_gem 'net-ssh','~>1.0.2'

class TNode
# Description: Generic node class 
  attr_reader :name, :type, :ccc, :re, :sid, :swno, :dirs
  def initialize(a_name, a_type, a_ccc, a_re, a_sid, a_swno, a_dirs)
    @name = a_name
    @type = a_type
    @ccc = a_ccc
    @re = a_re
    @sid = a_sid
    @swno = a_swno
    @dirs = a_dirs
    @block_state = 'IDLE'
  end
  def block
    @block_state = 'MBL'
  end
  def deblock
    @block_state = 'IDLE'
  end
  def is_blocked?
    @block_state == 'IDLE'
  end
  def to_s
    printf "%-26s%-7s%-5s%-4s%-8s%-6s%-6s\n", @name, @type, @ccc, @re, @sid, @swno, @block_state
  end
   def methods
    ['block', 'ccc', 'deblock', 'dirs', 'initialize', 'is_blocked?', 'methods', 'name', 're', 'sid', 'swno', 'to_s', 'type'].sort
  end
end

class TIOG < TNode
# Description: IOG node class
end

class TAPG < TNode
# Description : APG node class 
  attr_reader :ip
  def initialize(a_name, a_type, a_ccc, a_re, a_sid, a_swno, a_dirs, a_ip, a_user, a_passwd)
    super(a_name, a_type, a_ccc, a_re, a_sid, a_swno, a_dirs)
    @ip = a_ip
    @ping_state = 'NO'
    @user = a_user
    @passwd = a_passwd
    #ping
  end
  def ping
    if Ping.pingecho(@ip, 5)
      @ping_state = 'YES'
      true
    else
      @ping_state = 'NO'
      false
    end
  end
  def to_s
    printf "%-26s%-7s%-5s%-4s%-8s%-6s%-6s%-5s%-17s\n", @name, @type, @ccc, @re, @sid, @swno, @block_state, @ping_state, @ip
  end
  def send_cmd2(a_cmd)
    Net::SSH.start(@ip, @user, @passwd) do |session|
      session.open_channel do |channel|
        channel.on_data do |ch,data|
          data=~/Release:/
          if ($') != nil
              a=($').gsub(' ','')
              puts a
          end
        end
        channel.exec a_cmd
      end
      session.loop
      session.close
    end  
  end
  def send_cmd (a_cmd)
    Net::SSH.start(@ip, @user, @passwd) do |session|
      session.open_channel do |channel|
        channel.on_success do
          puts "shell was started successfully!"
          channel.send_data a_cmd 
          channel.send_data "exit\n"
        end
        channel.on_failure do
          $stderr.puts "shell could not be started!"
        end
        channel.on_data do |ch,data|
          data=~/Release:/
          if ($') != nil
              oss_version=($').gsub(' ','') 
              puts oss_version
          end
        end
        channel.on_close do
          puts "shell terminated"
        end
        channel.send_request "shell", nil, true
      end
      session.loop
      session.close
    end  
  end
  def methods
    (super + ['ip', 'ping']).sort
  end
end

class TNodeList < Array
  def blockall
    each {|a_node| a_node.block}
  end
  def deblockall
    each {|a_node| a_node.deblock}
  end
  def blockall_no_pinging
    each do |a_node|
      if a_node.type != 'IOG11'
        if !a_node.ping
          a_node.block
        end
      end
    end
  end
  def pingall
    each {|a_node| a_node.ping if a_node.type != 'IOG11'}
  end
  def select_node(key)
    if key.kind_of?(Integer)
      [key]
    else
      find {|a_node| key == a_node.name}
    end
  end
  def to_s
    each {|a_node| a_node.to_s}
  end
  def methods
    ['blockall', 'blockall_no_pinging', 'deblockall', 'methods', 'select_node', 'to_s'].sort
  end
end

class TFGR
  attr_reader :nodelist
  def initialize
    @nodelist = TNodeList.new
    @nodelist.push(TIOG.new('GTW_CAMPINAS_CASTELO'   , 'IOG11', 'ERI', 'SP','000043', '0003', 'CAMPINAS'))
    @nodelist.push(TIOG.new('GTW_SAO_JOSE_DOS_CAMPOS', 'IOG11', 'ERI', 'SP','000027', '0004', 'SAO_JOSE'))
    @nodelist.push(TIOG.new('GTW_ARARAQUARA'         , 'IOG11', 'ERI', 'SP','000063', '0006', 'ARARAQUA'))
    @nodelist.push(TIOG.new('GTW_BAURU'              , 'IOG11', 'ERI', 'SP','000033', '0003', 'BAURU3'))
    @nodelist.push(TAPG.new('GTW_TATUAPE_I'          , 'APG30', 'ERI', 'SP','000003', '0053', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_TATUAPE_II'         , 'APG40', 'ERI', 'SP','031885', '0166', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_SANTOS_SP'          , 'APG40', 'ERI', 'SP','031885', '0104', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_CAMPINAS_BONFIM'    , 'APG40', 'ERI', 'SP','031885', '0111', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_JAGUARE_I'          , 'APG40', 'ERI', 'SP','031885', '0117', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_JAGUARE_II'         , 'APG40', 'ERI', 'SP','031885', '0118', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_MORUMBI_SEDE_I'     , 'APG40', 'ERI', 'SP','031885', '0112', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_MORUMBI_SEDE_II'    , 'APG40', 'ERI', 'SP','031885', '0113', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_CURITIBA_I'         , 'APG30', 'ERI', 'PR','000320', '0026', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_CURITIBA_II'        , 'APG40', 'ERI', 'PR','031874', '0027', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('ALTO_PETROPOLIS'        , 'APG30', 'ERI', 'RS','000259', '0008', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('BELA_VISTA'             , 'APG30', 'ERI', 'RS','000259', '0001', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('CAXIAS_DO_SUL'          , 'APG30', 'ERI', 'RS','000261', '0001', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('JARDIM_ITU'             , 'APG30', 'ERI', 'RS','000259', '0011', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('MATRIZ'                 , 'APG30', 'ERI', 'RS','000259', '0003', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('NOVO_HAMBURGO'          , 'APG30', 'ERI', 'RS','000259', '0006', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('PASSO_FUNDO'            , 'APG30', 'ERI', 'RS','000261', '0002', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('PELOTAS'                , 'APG30', 'ERI', 'RS','000257', '0001', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('SANTA_CRUZ_DO_SUL'      , 'APG30', 'ERI', 'RS','000259', '0007', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('SANTA_MARIA'            , 'APG30', 'ERI', 'RS','000263', '0001', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('SANTO_ANGELO'           , 'APG30', 'ERI', 'RS','000263', '0002', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('SAO_JOAO'               , 'APG30', 'ERI', 'RS','000259', '0005', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('BELA_VISTA_PILAR'       , 'APG40', 'ERI', 'RS','031873', '0002', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('INDEPENDENCIA'          , 'APG40', 'ERI', 'RS','031873', '0008', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_ENGENHO_DE_DENTRO'  , 'APG30', 'ERI', 'RJ','032121', '0044', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_NITEROI'            , 'APG30', 'ERI', 'RJ','032121', '0046', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_TIJUCA_I'           , 'APG40', 'ERI', 'RJ','031893', '0057', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GTW_TIJUCA_II'          , 'APG40', 'ERI', 'RJ','031893', '0058', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TIOG.new('ARACAJU'                , 'IOG11', 'ERI', 'CO','001443', '0001', 'ARACAJU'))
    @nodelist.push(TAPG.new('SALVADOR'               , 'APG30', 'ERI', 'CO','031907', '0013', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('VILA_LAURA'             , 'APG40', 'ERI', 'CO','031907', '0014', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('CUIABA'                 , 'APG30', 'ERI', 'CO','001569', '0002', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('SINOP'                  , 'APG30', 'ERI', 'CO','001581', '0001', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('CAMPO_GRANDE'           , 'APG30', 'ERI', 'CO','000703', '0003', 'CDRs30', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('PORTO_VELHO'            , 'APG33', 'ERI', 'CO','001521', '0002', 'CDRs33', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('BRASILIA_10'            , 'APG40', 'ERI', 'CO','000131', '0010', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('BRASILIA_11'            , 'APG40', 'ERI', 'CO','000131', '0011', 'CDRs40', '146.250.143.45', 'enogrob', 'enogrob'))
    @nodelist.push(TAPG.new('GOIANIA_1'              , 'APG40', 'ERI', 'CO','001313', '0005', 'CDRs40', '146.250.131.61', 'enogrob', 'enogrob'))
  end
  def methods
    ['new'].sort
  end
end

fgr = TFGR.new
#fgr.nodelist.pingall
GOIANIA_1=fgr.nodelist.select_node('GOIANIA_1')
GOIANIA_1.ping
GOIANIA_1.to_s
#GOIANIA_1.send_cmd("infoXtract.sh \| head\n")
GOIANIA_1.send_cmd2("infoXtract.sh \| head\n") 






