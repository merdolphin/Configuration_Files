#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Script to modify kernel config based on lsmod output
Copyright (C) 2008  Andreas Goelzer
 
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 
Based on a previous config and the output of lsmod, this script determines
which modules could be compiled in and generates a new config.
See http://andreas.goelzer.de/kernel-config-based-on-lsmod-output for updates
"""

import re;
from optparse import OptionParser;
from os import popen;
from sys import stderr, stdout, stdin;

parser = OptionParser(version="%prog 0.31");
parser.add_option("-i", "--infile", dest="cfgfile",
                  help="input config file", default=".config", metavar="FILE");
parser.add_option("-o", "--outfile", dest="outfile",
                  help="output config file", default="-", metavar="FILE");
parser.add_option("-l", "--logfile", dest="logfile",
                  help="file to log errors to", default="-", metavar="FILE");
parser.add_option("-s", "--sourcedir", dest="sourcedir",
                  help="kernel source tree", default=".", metavar="DIR");
#parser.add_option("-v", "--verbose",
                  #action="store_true", dest="verbose", default=False,
                  #help="print debug messages");

(options, args) = parser.parse_args();
if(options.outfile == '-'): of = stdout;
else: of = open(options.outfile, 'w');
if(options.logfile != '-'): stderr = open(options.logfile, 'w');


loadedmods=popen('lsmod | tail -n+2').readlines();
getmodname=re.compile(r"^(?P<modname>\w*)");

#prob. need to replace kernel with sth. like (kernel|ubuntu) for an ubuntu kernel source
parsepath=re.compile(r"/kernel(?P<path>/.*/)(?P<file>.*).ko")

wantin=[];
for module in loadedmods:
	modname = re.search(getmodname,module).group('modname');
	moduleprops=re.search(parsepath,popen('modinfo -n ' + modname).read());
	if(moduleprops):
		#search the makefile for the module name
		try:
			f=open(options.sourcedir + moduleprops.group('path') + 'Makefile' , 'r');
		except IOError:
			stderr.write('Could not find Makefile for ' + modname + '\n');
			continue
		cont=f.read();
		f.close();
		m=re.search(r"obj-\$\((?P<cfgname>[A-Z0-9_]*)\)\W*\+=\W*"+moduleprops.group('file')+r"\.o",cont);
		if(m):wantin.append(m.group('cfgname'));
		else:stderr.write('Could not determine config name for ' + modname + '\n');
	else:
		stderr.write('Could not parse modinfo for ' + modname + '\n');



if(options.cfgfile != '-'): 
	f=open(options.cfgfile, 'r');
	lines=f.readlines();
	f.close();
else:
	lines=stdin.readlines();

confparse = re.compile(r"\W*(?P<iscomment>#?)\W*(?P<cfgname>CONFIG_[A-Z0-9_]*)\W*=?\W*(?P<answer>[nmy]?)");

for line in lines:
	matches = re.search(confparse,line);
	if(matches and matches.group('cfgname') in wantin): 
		of.write(matches.group('cfgname')+'=y\n');
	else: 
		#if(matches and matches.group('answer') == 'm'):of.write(matches.group('cfgname')+'=n\n');
		of.write(line);