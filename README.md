# AXE-ENGINE

```
Copyright (C) 2006 by Ericsson, GSDC Brazil, SW Deployment C.C.
axe_engine v0.0.1
```

AXE-ENGINE is a simple RubyGem package to provide some functions for handling
Ericsson AXE printouts.


`cmd_list` - List AXE commands specifications contained in a command log file.
* Input is the full specification of command log file.
* Output is a sorted array of AXE command specifications.
 
e.g. Using irb - Ruby Shell

```
irb(main):001:0> require 'rubygems'
=> true
irb(main):002:0> require 'axe_engine'
=> true
irb(main):003:0> cmd_list('C:\Documents and Settings\enogrob\My Documents\My Logs FNI\TGU_BSC_pre_study.log')
=> ["C7LTP:LS=ALL;", "DBTSP:TAB=AXEPARFAULTS;", "DBTSP:TAB=AXEPARS;", "DBTSP:TAB=TABLES,FCERROR=YES;",
"EXEMP:RP=ALL,EM=ALL;", "EXRIP:RP=ALL,PID;", "EXRPP:RP=ALL;", "EXRUP:RP=ALL;", "IOEXP;"]
irb(main):004:0>
```

**Note:** The output is also copied to Clipboard.


`cmd_get` - Get an AXE command printout contained in a command log file.
* Input is the full specification of command log file, and the AXE command.
* Output is an array of AXE command printout.
 
e.g. Using irb - Ruby Shell

```
irb(main):001:0> require 'rubygems'
=> true
irb(main):002:0> require 'axe_engine'
=> true
irb(main):003:0> cmd_get('C:\Documents and Settings\enogrob\My Documents\My Logs FNI\TGU_BSC_pre_study.log', 'IOEXP')
=> ["<IOEXP;", "EXCHANGE IDENTITY DATA", "", "IDENTITY", "BSC17A02G2140_0A.REF", "", "END"]
irb(main):004:0> 
```

**Note:** The output is also copied to Clipboard.


Examples of use, see examples under directory `tests`.
**Note:** These scripts, in order to run properly, has to be placed in a directory
which is included into the `Path` environment variable and also the extension `.rb`
associated with the Ruby interpreter.

Script `cmdlist.rb` to test `cmd_list`.
e.g. Using Windows Shell

```
C:\Documents and Settings\enogrob\My Documents>cd "My Logs FNI"

C:\Documents and Settings\enogrob\My Documents\My Logs FNI>dir
 Volume in drive C is ESOE_W2K
 Volume Serial Number is 74EB-70C6

 Directory of C:\Documents and Settings\enogrob\My Documents\My Logs FNI

09/08/2006  01:24       <DIR>          .
09/08/2006  01:24       <DIR>          ..
30/06/2006  08:50       <DIR>          ACA8_9_10B
:
01/06/2006  01:49              354.302 TGU_BSC_pre_study.log
              10 File(s)        578.519 bytes
               4 Dir(s)   8.177.799.680 bytes free

C:\Documents and Settings\enogrob\My Documents\My Logs FNI>cmdlist.rb TGU_BSC_pre_study.log
C7LTP:LS=ALL;
DBTSP:TAB=AXEPARFAULTS;
DBTSP:TAB=AXEPARS;
DBTSP:TAB=TABLES,FCERROR=YES;
EXEMP:RP=ALL,EM=ALL;
EXRIP:RP=ALL,PID;
EXRPP:RP=ALL;
EXRUP:RP=ALL;
IOEXP;
```

Script `cmdprint.rb` to test `cmd_get`.
e.g. Using Windows Shell

```
CC:\Documents and Settings\enogrob\My Documents\My Logs FNI>cmdprint.rb TGU_BSC_pre_study.log IOEXP
<IOEXP;
EXCHANGE IDENTITY DATA

IDENTITY
BSC17A02G2140_0A.REF

END
``` 

