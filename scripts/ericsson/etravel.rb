#!C:\ruby\bin\ruby.exe

# Copyright (C) 2005 by Ericsson Serviços de Telecomunicações Ltda.
# Project  : 
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-06-24
# Revision : PA3
# Doc.Nr   : 
# Approved : EBS/HD/S  Bjorn Arvidsson
# Checked  : EBS/HD/SB Zoran Ovuka
# File     : etravel.rb

# Purpose  : Used to provide the eTravel classes.
require 'FileUtils'

class Etravel
  ETRAVEL_DIR = "C:\\Documents and Settings\\" + ENV['USERNAME'] + "\\My Documents\\My eTravels\\"
  ETRAVELFILE_DEF = "etravel_default.txt"
  ETRAVELFILE_CUR = "etravel_current.txt"
  
  CURRENCIES = [:BRL, :USD, :EUR]
  PAYED_BY   = [:amex, :cash]
  EXPENSES   = [:meal, :other, :hotel, :laundry, :transport, :phone, :draw, :personal]
  
  def initialize(a_eurrate=2.76590, a_etravel=ETRAVELFILE_DEF)
    @eur_rate = a_eurrate
    # Make eTravel directory if does not exist
    FileUtils.mkdir_p ETRAVEL_DIR
    # Goto eTravel directory
    Dir.chdir(ETRAVEL_DIR)
    #
    if File.exist?(ETRAVEL_DIR + ETRAVELFILE_CUR)
      @current = IO.readlines(ETRAVEL_DIR + ETRAVELFILE_CUR)[0].chomp
    else
      @current = nil
    end
    #
    if File.exist?(ETRAVEL_DIR + @current)
      puts "=> eTravel: \"#{@current}\" will be opened  !"
    else
      puts "=> eTravel: \"#{@current}\" will be created !"
    end
    #
    File.open(ETRAVEL_DIR + ETRAVELFILE_CUR, 'w') do |file|
      file.print "#{@current}"
    end
  end
  
  def current
    if File.exist?(ETRAVEL_DIR + ETRAVELFILE_CUR)
      puts "=> eTravel: \"#{@current}\" is the current one !"
    else
      puts "=> eTravel: current is still not defined !"
    end
  end
  
  def add(*args)
    a_expense  = :meal
    a_payed_by = :cash
    a_currency = :BRL
    #
    args.each do |arg|
      if arg.kind_of? Symbol
        if EXPENSES.include?(arg)
          a_expense = arg
        elsif PAYED_BY.include?(arg)
          a_payed_by = arg
        elsif CURRENCIES.include?(arg)
          a_currency = arg
        else
          puts "=> eTravel: \"#{arg}\" is not standard !"
          return
        end
      elsif arg.kind_of? Float
      else
        puts "=> eTravel: \"#{arg}\" is of wrong type !"
        return
      end
    end
    #
    File.open(ETRAVEL_DIR + @current, 'a+') do |file|
      line_no = 0
      total = 0.00
      args.each do |a_value|
        if a_value.kind_of? Float
          line_no += 1
          file.printf "%-11s %-10s %-5s %-4s %12.2f\n", Time.now.strftime('%d-%m-%Y'), a_expense, a_payed_by, a_currency, a_value
          total+= a_value
        end
      end
      printf "#{line_no} x TOTAL (#{a_currency}) %40.2f\n", total
    end
  end
  
  def get(a_etravel=@current)
    if File.exist?(ETRAVEL_DIR + a_etravel)
      IO.readlines(ETRAVEL_DIR + a_etravel) 
    else
      puts "=> eTravel: \"#{a_etravel}\" does not exist !"
    end
  end
  
  def summary(*filters)
    line_no = 0
    total = 0
    get.each do |line| 
      if filters.all? {|filter| line.include?(filter.to_s)}
        line_no += 1
        printf "%-5i %s", line_no, line
        total+= line.chomp.split[-1].to_f
      end
    end
    currency = CURRENCIES.select {|cur| filters.include?(cur)}
    printf "TOTAL (#{currency}) %40.2f\n", total
    if currency[0] == :EUR
      printf "TOTAL (BRL) %40.2f\n\n", (total = total * @eur_rate)
    else
      puts
    end
    [line_no, total]
  end
  
  def balance(a_cash=115.00)
    balance = a_cash * @eur_rate
    balance += summary(:meal, :cash, :EUR)[1]
    balance += summary(:meal, :cash, :BRL)[1]
    balance += summary(:transport, :cash, :EUR)[1]
    balance += summary(:transport, :cash, :BRL)[1]
    #balance += summary(:transport, :amex, :BRL)[1]
    balance += summary(:other, :cash, :EUR)[1]
    #balance += summary(:other, :amex, :EUR)[1]
    balance += summary(:phone, :cash, :EUR)[1]
    balance -= summary(:draw, :amex, :EUR)[1]
    balance -= summary(:personal, :cash, :EUR)[1]
    balance -= summary(:personal, :amex, :EUR)[1]
    printf "BALAN (BRL) %40.2f\n", balance
    printf "BALAN (EUR) %40.2f\n", (balance / @eur_rate)
  end
  
end