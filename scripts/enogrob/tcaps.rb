#!C:\ruby\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-02-08
# Revision : PA2
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : tcaps.rb

# Purpose  : Used to provide the tcaps verification.

require 'enogrob/bradesco'
require 'enogrob/clip'

bradesco = TBradesco.new
clip = Clipboard.instance 
result = clip.copy
bradesco.match_tcaps?(result) if (result=~/\d2*/) != nil
gets
