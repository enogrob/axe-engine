#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Eduardo Lima
# Date     : 2006-08-03
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : psfolder_filter.rb
# Purpose  : Reads and filters emails from a Personal Folder in Outlook.
#++

require 'win32ole'

def foa_each_mail
  ol = WIN32OLE::connect("Outlook.Application")
  myNameSpace = ol.getNameSpace("MAPI")

  # GetDefaultFolder
  # 3 = Deleted Items
  # 5 = Sent Itens
  # 6 = Inbox
  # 16 = Drafts
  folder = myNameSpace.Folders
  myFolder = folder.Item("Personal Folders").Folders("GSDC")
  myFolder.Items.each do |mail|
  GC.start
  yield mail
  end
end

foa_each_mail do |mail|
  if mail.Subject.match("ECN") #Filter in email Subject 
    puts "\nSubject:\t" + mail.Subject
    puts "Sender :\t" + mail.SenderName
    puts "Sent :\t" + mail.ReceivedTime
    puts "Size :\t" + mail.Size.to_s + " bytes"
    puts "\nBody message:\n" + mail.Body.match("ECN").to_s # Filter in the email body 
  end
end