#!C:\Program Files\ruby-1.8\bin\ruby.exe
#--
# Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
# KSTool   : Ruby Programming community
# Prepared : EBS/HD/SB Roberto Nogueira
# Date     : 2006-08-07
# Version  : 0.0.1
# Ruby     : 1.8.4
# Windows  : 2000
# File     : axe-engine-0.0.1.gemspec
# Purpose  : A package specification for handling Ericsson AXE printouts.
#++

require 'rubygems'

Gem::manage_gems
require 'rake/gempackagetask'
spec = Gem::Specification.new do |s|
    s.platform  =   Gem::Platform::RUBY
    s.name      =   "axe-engine"
    s.version   =   "0.0.1"
    s.author    =   "Roberto Nogueira"
    s.email     =   "enogrob@hotmail.com"
    s.summary   =   "A package for handling Ericsson AXE printouts."
    s.files     =   FileList['lib/*.rb', 'tests/*.rb'].to_a
    s.require_path  =   "lib"
    s.autorequire   =   "axe_engine"
    s.test_files = Dir.glob('tests/*.rb')
    s.has_rdoc  =   true
    s.extra_rdoc_files  =   ["README"]
end
Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end
task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end